# Encoding: utf-8

require 'thor'
require 'rspec'
require 'rspec/retry'
require 'chemistrykit/cli/new'
require 'chemistrykit/cli/formula'
require 'chemistrykit/cli/beaker'
require 'chemistrykit/cli/helpers/formula_loader'
require 'chemistrykit/catalyst'
require 'chemistrykit/formula/base'
require 'chemistrykit/formula/formula_lab'
require 'chemistrykit/chemist/repository/csv_chemist_repository'
require 'selenium_connect'
require 'chemistrykit/configuration'
require 'parallel_tests'
require 'chemistrykit/parallel_tests/rspec/runner'
require 'chemistrykit/rspec/j_unit_formatter'

require 'rspec/core/formatters/html_formatter'
require 'chemistrykit/rspec/html_formatter'

require 'chemistrykit/reporting/html_report_assembler'
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

      desc 'tags', 'Lists all tags in use in the test harness.'
      def tags
        beakers = Dir.glob(File.join(Dir.getwd, 'beakers/*'))
        ::RSpec.configure do |c|
          c.add_setting :used_tags
          c.before(:suite) { ::RSpec.configuration.used_tags = [] }
          c.around(:each) do |example|
            standard_keys = [:example_group, :example_group_block, :description_args, :caller, :execution_result]
            example.metadata.each do |key, value|
              tag = "#{key}:#{value}" unless standard_keys.include?(key)
              ::RSpec.configuration.used_tags.push tag unless ::RSpec.configuration.used_tags.include?(tag) || tag.nil?
            end
          end
          c.after(:suite) do
            puts "\nTags used in harness:\n\n"
            puts ::RSpec.configuration.used_tags.sort
          end
        end
        ::RSpec::Core::Runner.run(beakers)
      end

      desc 'brew', 'Run ChemistryKit'
      method_option :params, type: :hash
      method_option :tag, type: :array
      method_option :config, default: 'config.yaml', aliases: '-c', desc: 'Supply alternative config file.'
      # TODO: there should be a facility to simply pass a path to this command
      method_option :beakers, aliases: '-b', type: :array
      # This is set if the thread is being run in parallel so as not to trigger recursive concurency
      method_option :parallel, default: false
      method_option :results_file, aliases: '-r', default: false, desc: 'Specifiy the name of your results file.'
      method_option :all, default: false, aliases: '-a', desc: 'Run every beaker.', type: :boolean
      method_option :retry, default: false, aliases: '-x', desc: 'How many times should a failing test be retried.'

      def brew
        config = load_config options['config']
        # TODO: perhaps the params should be rolled into the available
        # config object injected into the system?
        pass_params if options['params']

        # replace certain config values with run time flags as needed
        config = override_configs options, config

        load_page_objects

        # get those beakers that should be executed
        beakers = options['beakers'] ? options['beakers'] : Dir.glob(File.join(Dir.getwd, 'beakers/*'))

        if options['beakers']
          # if a beaker(s) defined use them
          beakers = options['beakers']
          # if tags are explicity defined, apply them to the selected beakers
          setup_tags(options['tag'])
        else
          # beakers default to everything
          beakers = Dir.glob(File.join(Dir.getwd, 'beakers/*'))

          if options['tag']

            # if tags are explicity defined, apply them to all beakers
            setup_tags(options['tag'])
          else
            # else choose the default tag
            setup_tags(['depth:shallow'])
          end
        end

        # configure rspec
        rspec_config(config)

        # based on concurrency parameter run tests
        if config.concurrency > 1 && ! options['parallel']
          exit_code = run_in_parallel beakers, config.concurrency, @tags, options
        else
          exit_code = run_rspec beakers
        end

        process_html unless options['parallel']
        exit_code unless options['parallel']
      end

      protected

      def process_html
        puts 'PROCESS HTML CALLED'
        File.join(Dir.getwd, 'evidence')
        results_folder = File.join(Dir.getwd, 'evidence')
        output_file = File.join(Dir.getwd, 'evidence', 'final_results.html')
        assembler = ChemistryKit::Reporting::HtmlReportAssembler.new(results_folder, output_file)
        assembler.assemble
      end

      def override_configs(options, config)
        # TODO: expand this to allow for more overrides as needed
        config.log.results_file = options['results_file'] if options['results_file']
        config.retries_on_failure = options['retry'].to_i if options['retry']
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

      def setup_tags(selected_tags)
        @tags = {}
        selected_tags.each do |tag|
          filter_type = tag.start_with?('~') ? :exclusion_filter : :filter

          name, value = tag.gsub(/^(~@|~|@)/, '').split(':')
          name = name.to_sym

          value = true if value.nil?

          @tags[filter_type] ||= {}
          @tags[filter_type][name] = value
        end unless selected_tags.nil?
      end

      # rubocop:disable MethodLength
      def rspec_config(config) # Some of these bits work and others don't
        ::RSpec.configure do |c|
          c.treat_symbols_as_metadata_keys_with_true_values = true
          unless options[:all]
            c.filter_run @tags[:filter] unless @tags[:filter].nil?
            c.filter_run_excluding @tags[:exclusion_filter] unless @tags[:exclusion_filter].nil?
          end
          c.before(:all) do
            @config = config # set the config available globaly
            ENV['BASE_URL'] = config.base_url # assign base url to env variable for formulas
          end
          c.around(:each) do |example|
            # create the beaker name from the example data
            beaker_name = example.metadata[:example_group][:description_args].first.downcase.strip.gsub(' ', '_').gsub(/[^\w-]/, '')
            test_name = example.metadata[:full_description].downcase.strip.gsub(' ', '_').gsub(/[^\w-]/, '')

            # override log path with be beaker sub path
            sc_config = @config.selenium_connect.dup
            sc_config[:log] += "/#{beaker_name}"
            beaker_path = File.join(Dir.getwd, sc_config[:log])
            Dir.mkdir beaker_path unless File.exists?(beaker_path)
            sc_config[:log] += "/#{test_name}"
            test_path = File.join(Dir.getwd, sc_config[:log])
            Dir.mkdir test_path unless File.exists?(test_path)

            # configure and start sc
            configuration = SeleniumConnect::Configuration.new sc_config
            @sc = SeleniumConnect.start configuration
            @job = @sc.create_job # create a new job
            @driver = @job.start name: test_name

            # TODO: this is messy, and could be refactored out into a static on the lab
            chemist_data_paths = Dir.glob(File.join(Dir.getwd, 'chemists', '*.csv'))
            repo = ChemistryKit::Chemist::Repository::CsvChemistRepository.new chemist_data_paths
            # make the formula lab available
            @formula_lab = ChemistryKit::Formula::FormulaLab.new @driver, repo, File.join(Dir.getwd, 'formulas')

            example.run
          end
          c.before(:each) do
            # basic auth caching
            if config.basic_auth[:username]
              if config.basic_auth[:http_path]
                basic_auth_http_url = config.base_url.gsub(%r{http://}, "http:\/\/#{config.basic_auth[:username]}:#{config.basic_auth[:password]}@") + config.basic_auth[:http_path]
                @driver.get basic_auth_http_url
              else
                basic_auth_http_url = config.base_url.gsub(%r{http://}, "http:\/\/#{config.basic_auth[:username]}:#{config.basic_auth[:password]}@")
                @driver.get basic_auth_http_url
              end
              if config.basic_auth[:https_path]
                basic_auth_https_url = config.base_url.gsub(%r{http://}, "https:\/\/#{config.basic_auth[:username]}:#{config.basic_auth[:password]}@") + config.basic_auth[:https_path]
                @driver.get basic_auth_https_url
              end
            end
          end
          c.after(:each) do
            if example.exception.nil? == false
              @job.finish failed: true, failshot: @config.screenshot_on_fail
            else
              @job.finish passed: true
            end
            @sc.finish
          end
          c.order = 'random'
          c.default_path = 'beakers'
          c.pattern = '**/*_beaker.rb'
          c.output_stream = $stdout
          c.add_formatter 'progress'

          html_log_name = options[:parallel] ? "results_#{options[:parallel]}.html" : 'results_0.html'

          c.add_formatter(ChemistryKit::RSpec::HtmlFormatter, File.join(Dir.getwd, config.log.path, html_log_name))
          # c.add_formatter(::RSpec::Core::Formatters::HtmlFormatter, File.join(Dir.getwd, config.log.path, html_log_name))

          # for rspec-retry
          c.verbose_retry = true # for rspec-retry
          c.default_retry_count = config.retries_on_failure

          if config.concurrency == 1 || options['parallel']
            junit_log_name = options[:parallel] ? "junit_#{options[:parallel]}.xml" : 'junit.xml'
            c.add_formatter(ChemistryKit::RSpec::JUnitFormatter, File.join(Dir.getwd, config.log.path, junit_log_name))
          end
        end
      end
      # rubocop:enable MethodLength

      def run_in_parallel(beakers, concurrency, tags, options)
        unless options[:all]
          tag_string = tags.empty? ? nil : '--tag=' + tags[:filter].map { |k, v| "#{k}:#{v}" }.join(' ')
        end
        config_string = '--config=' + options['config']
        args = %w(--type rspec) + ['-n', concurrency.to_s] + ['-o', "#{config_string} #{tag_string} --beakers="] + beakers
        ParallelTests::CLI.new.run(args)
      end

      def run_rspec(beakers)
        ::RSpec::Core::Runner.run(beakers)
      end
    end # CkitCLI
  end # CLI
end # ChemistryKit
