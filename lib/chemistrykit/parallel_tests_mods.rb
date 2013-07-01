require 'parallel_tests/rspec/runner'
require "parallel_tests/test/runner"

module ParallelTests
  module RSpec
    class Runner < ParallelTests::Test::Runner

      class << self

        def run_tests(test_files, process_number, num_processes, options)
          exe = executable # expensive, so we cache
          version = (exe =~ /\brspec\b/ ? 2 : 1)

#          cmd = [exe, options[:test_options], (rspec_2_color if version == 2), spec_opts, *test_files].compact.join(" ")
          cmd = exe # ckit doesn't take additional args, rewrote the above line with this one

          options = options.merge(:env => rspec_1_color) if version == 1
          execute_command(cmd, process_number, num_processes, options)
        end

        def determine_executable
          'bundle exec ckit brew'
        end

        def test_file_name
          'beaker'
        end

        def test_suffix
          '_beaker.rb'
        end

        def runtime_log
          File.join(Dir.getwd, 'evidence', 'parallel_runtime_rspec.log')
        end

      end #self
    end #Runner
  end #RSpec
end #ParallelTests
