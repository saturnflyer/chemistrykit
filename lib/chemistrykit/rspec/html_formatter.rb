# Encoding: utf-8

require 'rspec/core/formatters/base_text_formatter'
require 'chemistrykit/rspec/core/formatters/html_printer'

module ChemistryKit
  module RSpec
    class HtmlFormatter < ::RSpec::Core::Formatters::BaseTextFormatter

      def initialize(output)
        super(output)
        @example_group_number = 0
        @example_number = 0
      end

      def message(message)
      end

      def start(example_count)
        super(example_count)
        @output_lines = []
      end

      def example_group_started(example_group)
        @example_group = example_group
        @example_group_lines = []
        @example_group_status = 'passed'
      end

      def example_group_finished(example_group)
        @output_lines << "<div class=\"group #{@example_group_status}\">"
        @output_lines += @example_group_lines
        @output_lines << '</div>'
      end

      def example_started(example)
        super(example)
        @example_number += 1
      end

      def example_passed(example)
        @example_group_lines << "<div class=\"example passed\">"
        @example_group_lines << "<h1>#{example.description}</h1>"
        @example_group_lines << '</div>'
      end

      # def example_pending(example)
      #   @pending_examples << example
      # end

      def example_failed(example)
        super(example)
        @example_group_status = 'failed'
        @example_group_lines << "<div class=\"example failed\">"
        @example_group_lines << "<h1>#{example.description}</h1>"
        @example_group_lines << '</div>'
      end

      def dump_failures
      end

      def dump_pending
      end

      def dump_summary(duration, example_count, failure_count, pending_count)
        # @duration = duration
        # @example_count = example_count
        # @failure_count = failure_count
        # @pending_count = pending_count
        summary_lines = []
        summary_lines << "<div class=\"results_part\" data-count=\"#{example_count}\" data-durration=\"#{duration}\" data-failures=\"#{failure_count}\" data-pendings=\"#{pending_count}\">"
        summary_lines += @output_lines
        summary_lines << '</div>'

        @output.puts summary_lines.join($RS)
      end

      # def extra_failure_content(exception)
      #   super + "<h1>Ya'll know we be failing.</h1>"
      # end
    end
  end
end



