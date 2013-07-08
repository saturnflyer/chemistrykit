# Encoding: utf-8

require 'thor'
require 'rspec'
require 'yarjuf'
require 'chemistrykit/cli/new'
require 'chemistrykit/cli/formula'
require 'chemistrykit/cli/beaker'
require 'chemistrykit/cli/helpers/formula_loader'
require 'chemistrykit/catalyst'
require 'chemistrykit/formula/base'
require 'selenium-connect'
require 'chemistrykit/configuration'
require 'parallel_tests'
require 'chemistrykit/parallel_tests_mods'

module ChemistryKit
  module CLI

    # Registers the formula and beaker commands
    class Generate < Thor
      register(ChemistryKit::CLI::FormulaGenerator, 'formula', 'formula [NAME]', 'generates a page object')
      register(ChemistryKit::CLI::BeakerGenerator, 'beaker', 'beaker [NAME]', 'generates a beaker')
    end

    # Main Chemistry Kit CLI Class
    class CKitCLI < Thor

      register(ChemistryKit::CLI::New, 'new', 'new [NAME]', 'Creates a new ChemistryKit project')
      check_unknown_options!
      default_task :help

      desc 'generate SUBCOMMAND', 'generate <formula> or <beaker> [NAME]'
      subcommand 'generate', Generate

      desc 'brew', 'Run ChemistryKit'
      method_option :params, type: :hash
      method_option :tag, default: ['depth:shallow'], type: :array
      method_option :config, default: 'config.yaml', aliases: '-c', desc: 'Supply alternative config file.'
      # TODO there should be a facility to simply pass a path to this command
      method_option :beakers, type: :array
      # This is set if the thread is being run in parallel so as not to trigger recursive concurency
      method_option :parallel, default: false
      method_option :results_file, default: false

      def brew
        config = load_config options['config']
        # TODO perhaps the params should be rolled into the available
        # config object injected into the system?
        pass_params if options['params']

        # replace certain config values with run time flags as needed
        config = override_configs options, config

        load_page_objects
        setup_tags
        # configure rspec
        rspec_config(config)
        # get those beakers that should be executed
        beakers = options['beakers'] ? options['beakers'] : Dir.glob(File.join(Dir.getwd, 'beakers/*'))
        # based on concurrency parameter run tests
        if config.concurrency > 1 && ! options['parallel']
          run_in_parallel beakers, config.concurrency
        else
          run_rspec beakers
        end

      end

      protected

      def override_configs(options, config)
        # TODO expand this to allow for more overrides as needed
        if options['results_file']
          config.log.results_file = options['results_file']
        end
        config
      end

      def pass_params
        options['params'].each_pair do |key, value|
          ENV[key] = value
        end
      end

      def load_page_objects
        loader = ChemistryKit::CLI::Helpers::FormulaLoader.new
        loader.get_formulas(File.join(Dir.getwd, 'formulas')).each { |file| require file }
      end

      def load_config(file_name)
        config_file = File.join(Dir.getwd, file_name)
        ChemistryKit::Configuration.initialize_with_yaml config_file
      end

      def setup_tags
        @tags = {}
        options['tag'].each do |tag|
          filter_type = tag.start_with?('~') ? :exclusion_filter : :filter

          name, value = tag.gsub(/^(~@|~|@)/, '').split(':')
          name = name.to_sym

          value = true if value.nil?

          @tags[filter_type] ||= {}
          @tags[filter_type][name] = value
        end
      end

      def rspec_config(config) # Some of these bits work and others don't
        SeleniumConnect.configure do |c|
          c.populate_with_hash config.selenium_connect
        end
        RSpec.configure do |c|
          c.treat_symbols_as_metadata_keys_with_true_values = true
          c.filter_run @tags[:filter] unless @tags[:filter].nil?
          c.filter_run_excluding @tags[:exclusion_filter] unless @tags[:exclusion_filter].nil?
          c.before(:all) do
            # set the config available globaly
            @config = config
            # assign base url to env variable for formulas
            ENV['BASE_URL'] = config.base_url
          end
          c.before(:each) do
            @driver = SeleniumConnect.start
          end
          c.after(:each) do
            @driver.quit
          end
          c.after(:all) do
            SeleniumConnect.finish
          end
          c.order = 'random'
          c.default_path = 'beakers'
          c.pattern = '**/*_beaker.rb'
          c.output_stream = $stdout
          c.add_formatter 'progress'
          if config.concurrency == 1 || options['parallel']
            c.add_formatter(config.log.format, File.join(Dir.getwd, config.log.path, config.log.results_file))
          end
        end
      end

      def run_in_parallel(beakers, concurrency)

        ParallelTests::CLI.new.run(%w(--type rspec) + ['-n', concurrency.to_s] + %w(-o --beakers=) + beakers)
      end

      def run_rspec(beakers)
        RSpec::Core::Runner.run(beakers)
      end

    end # CkitCLI
  end # CLI
end # ChemistryKit
