# Encoding: utf-8

require 'rspec/core/formatters/base_text_formatter'
require 'chemistrykit/rspec/core/formatters/html_printer'
require 'nokogiri'
require 'erb'

module ChemistryKit
  module RSpec
    class HtmlFormatter < ::RSpec::Core::Formatters::BaseTextFormatter
      include ERB::Util # for the #h method
      def initialize(output)
        super(output)
        @example_group_number = 0
        @example_number = 0
      end

      def message(message)
      end

      def start(example_count)
        super(example_count)
        @output_html = ''
      end

      def example_group_started(example_group)
        @example_group = example_group
        @example_group_html = ''
        @example_group_number += 1
        @example_group_status = 'passed'
      end

      def example_group_finished(example_group)
        @output_html << build_fragment do |doc|
          doc.div(class: "row example-group #{@example_group_status}") {
            doc.div(class: 'large-12 columns') {
              doc.h3 {
                doc.i(class: 'icon-beaker')
                doc.text ' ' + example_group.description
              }
              doc.div(class: 'examples'){
                doc << @example_group_html
              }
            }
          }
        end
      end

      def example_started(example)
        super(example)
        @example_number += 1
      end

      def example_passed(example)
        @example_group_html += render_example('passing', example) {}
      end

      def example_pending(example)
        super(example)
        @example_group_html += render_example('pending', example) do |doc|
          doc.div(class: 'row exception') {
            doc.div(class: 'large-12 columns') {
              doc.pre {
                doc.text "PENDING: #{example.metadata[:execution_result][:pending_message]}"
              }
            }
          }
        end
      end

      def example_failed(example)
        super(example)
        @example_group_status = 'failing'
        @example_group_html += render_example('failing', example) do |doc|
          doc.div(class: 'row exception') {
            doc.div(class: 'large-12 columns') {
              doc.pre {
                exception = example.metadata[:execution_result][:exception]
                message = exception.message if exception
                doc.text message
              }
            }
          }
        end
      end

      def render_example(status, example)
        build_fragment do |doc|
          doc.div(class: "row example #{status}") {
            doc.div(class: 'large-12 columns') {
              doc.div(class: 'row example-heading') {
                doc.div(class: 'large-9 columns') {
                  doc.p { doc.text example.description.capitalize }
                }
                doc.div(class: 'large-3 columns text-right') {
                  doc.p { doc.text sprintf("%.0i", example.execution_result[:run_time]) + 's' }
                }
              }
              doc.div(class: 'row example-body') {
                doc.div(class: 'large-12 columns') {
                  yield doc
                }
              }
            }
          }
        end
      end


      def dump_failures
      end

      def dump_pending
      end

      def dump_summary(duration, example_count, failure_count, pending_count)
        output = build_fragment do |doc|
          doc.div(
            class: 'results',
            'data-count' => example_count.to_s,
            'data-duration' => duration.to_s,
            'data-failures' => failure_count.to_s,
            'data-pendings' => pending_count.to_s
            ) {
            doc << @output_html
          }
        end
        @output.puts output
      end

      # def extra_failure_content(exception)
      #   super + "<h1>Ya'll know we be failing.</h1>"
      # end
      #
      def build_fragment
        final = Nokogiri::HTML::DocumentFragment.parse ""
        Nokogiri::HTML::Builder.with(final) do |doc|
          yield doc
        end
        final.to_html
      end
    end
  end
end



