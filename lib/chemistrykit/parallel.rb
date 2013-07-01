require 'parallel_tests/rspec/runner'
require "parallel_tests/test/runner"

module ParallelTests
  module RSpec
    class Runner < ParallelTests::Test::Runner

      class << self

        def determine_executable
          'ckit brew'
        end

        def test_file_name
          'beaker'
        end

        def test_suffix
          '_beaker.rb'
        end

      end
    end
  end
end
