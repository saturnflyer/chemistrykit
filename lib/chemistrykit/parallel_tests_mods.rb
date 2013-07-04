# Encoding: utf-8

require 'parallel_tests/rspec/runner'
require 'parallel_tests/test/runner'

module ParallelTests
  module RSpec
    # Monkey Patching the ParallelTest RSpec Runner class to work with CKit's config and binary
    class Runner < ParallelTests::Test::Runner

      class << self

        def run_tests(test_files, process_number, num_processes, options)
          exe = executable # expensive, so we cache
          version = (exe =~ /\brspec\b/ ? 2 : 1)

        # // Beginning of method modifications //
        # cmd = [exe, options[:test_options], (rspec_2_color if version == 2), spec_opts, *test_files].compact.join(" ")
        # NOTE: The above line was modified to conform to ckit's command line constraints

          cmd = [exe, options[:test_options]].compact.join(' ')
          cmd << test_files.join(' ')
          puts cmd

        # This concatenates the command into `bundle exec ckit brew --beakers=beaker1 beaker2 beaker3 etc`
        # Which enables each test group to be run in its own command
        # --beakers= is set in lib/chemkistrykit/cli/cli.rb when parallel_tests is executed using its -o option flag

        # // End of method modifications //

          options = options.merge(env: rspec_1_color) if version == 1
          execute_command(cmd, process_number, num_processes, options)
        end

        def determine_executable
          'bundle exec ckit brew --parallel'
        end

        def test_file_name
          'beaker'
        end

        def test_suffix
          '_beaker.rb'
        end

        def runtime_log
          # TODO This needs to do something.
          File.join(Dir.getwd, 'evidence', 'parallel_runtime_rspec.log')
        end

      end # self
    end # Runner
  end # RSpec
end # ParallelTests
