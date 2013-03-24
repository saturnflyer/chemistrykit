require 'thor'
require 'rspec'
require 'ci/reporter/rake/rspec_loader'
require 'chemistrykit/cli/new'
require 'chemistrykit/cli/formula'
require 'chemistrykit/cli/beaker'
require 'turnip/rspec'

module ChemistryKit
  module CLI

    class Generate < Thor
      register(ChemistryKit::CLI::FormulaGenerator, 'formula', 'formula [NAME]', 'generates a page object')
      register(ChemistryKit::CLI::BeakerGenerator, 'beaker', 'beaker [NAME]', 'generates a beaker')
    end

    class CKitCLI < Thor
      register(ChemistryKit::CLI::New, 'new', 'new [NAME]', 'Creates a new ChemistryKit project')
      check_unknown_options!
      default_task :help

      desc "generate SUBCOMMAND", "generate <formula> or <beaker> [NAME]"
      subcommand "generate", Generate

      desc "brew", "Run ChemistryKit"
#      method_option :tag, :default => [':type => :feature'], :type => :array
      def brew
        require 'chemistrykit/config'
        require 'chemistrykit/shared_context'
        load_page_objects
        set_logs_dir
        turn_stdout_stderr_on_off
#        setup_tags
        rspec_config
        symlink_latest_report
        run_rspec
      end

      protected

      def load_page_objects
        Dir["#{Dir.getwd}/formulas/*.rb"].each {|file| require file }
      end

      def log_timestamp
        @log_timestamp = Time.now.strftime("%Y-%m-%d-%H-%M-%S")
      end

      def set_logs_dir
        ENV['CI_REPORTS'] = File.join(Dir.getwd, 'evidence', log_timestamp)
      end

      def turn_stdout_stderr_on_off
        ENV['CI_CAPTURE'] = CHEMISTRY_CONFIG['chemistrykit']['capture_output'] ? 'on' : 'off'
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

      def rspec_config
        RSpec.configure do |c|
#          c.filter_run @tags[:filter] unless @tags[:filter].nil?
#          c.filter_run_excluding @tags[:exclusion_filter] unless @tags[:exclusion_filter].nil?
          c.include ChemistryKit::SharedContext
          c.order = 'random'
          c.default_path = 'beakers'
          c.pattern = '**/*_beaker.rb'
          c.pattern << ',**/*.feature'
          c.treat_symbols_as_metadata_keys_with_true_values = true
        end
      end

      def symlink_latest_report
        case # Depending on platform, symlinks are done differently
        when RUBY_PLATFORM.downcase.include?("mswin")
          require 'win32/dir'
          if Dir.junction?(File.join(Dir.getwd, 'evidence', 'latest'))
            File.delete(File.join(Dir.getwd, 'evidence', 'latest'))
          end
          Dir.create_junction(File.join(Dir.getwd, 'evidence', 'latest'), File.join(Dir.getwd, 'evidence', @log_timestamp))
        else
          # This will work on any unix like platform
          FileUtils.ln_sf(File.join(Dir.getwd, 'evidence', @log_timestamp), File.join(Dir.getwd, 'evidence', 'latest'))
        end
      end

      def run_rspec
        RSpec::Core::Runner.run(Dir.glob(File.join(Dir.getwd)))
      end

    end
  end
end
