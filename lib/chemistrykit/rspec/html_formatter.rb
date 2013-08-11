# Encoding: utf-8

require 'rspec/core/formatters/base_text_formatter'
require 'chemistrykit/rspec/core/formatters/html_printer'
require 'nokogiri'
require 'erb'
require 'rspec/core/formatters/snippet_extractor'

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
        exception = example.metadata[:execution_result][:exception]
        @example_group_status = 'failing'
        @example_group_html += render_example('failing', example) do |doc|
          doc.div(class: 'row exception') {
            doc.div(class: 'large-12 columns') {
              doc.pre {
                message = exception.message if exception
                doc.text message
              }
            }
          }
          doc.div(class: 'row code-snippet') {
            doc.div(class: 'large-12 columns') {
              doc << render_code(exception)
            }
          }
          doc.div(class: 'row extra-content') {
            doc.div(class: 'large-12 columns') {
              doc.div(class: 'section-container auto', 'data-section' => ''){
                doc << render_stack_trace(example)
                doc << render_log_if_found(example, 'server.log')
                doc << render_log_if_found(example, 'chromedriver.log')
                doc << render_log_if_found(example, 'firefox.log')
                doc << render_log_if_found(example, 'sauce.log')
                doc << render_failshot_if_found(example)
              }
            }
          }
        end
      end

      # TODO: replace the section id with a uuid or something....
      def render_failshot_if_found(example)
        beaker_folder = slugify(@example_group.description)
        example_folder = slugify(@example_group.description + '_' + example.description)
        path = File.join(Dir.getwd, 'evidence', beaker_folder, example_folder, 'failshot.png' )
        if File.exist?(path)
          render_section('Failure Screenshot', 3) do |doc|
            doc.img(src: path)
          end
        end
      end

      def render_log_if_found(example, log)
        beaker_folder = slugify(@example_group.description)
        example_folder = slugify(@example_group.description + '_' + example.description)
        log_path = File.join(Dir.getwd, 'evidence', beaker_folder, example_folder, log )
        if File.exist?(log_path)
          render_section(log.capitalize, 2) do |doc|
            doc.pre {
              doc.text File.open(log_path, 'rb') { |file| file.read }
            }
          end
        end
      end

      def slugify(string)
        string.downcase.strip.gsub(' ', '_').gsub(/[^\w-]/, '')
      end

      def render_stack_trace(example)
        exception = example.metadata[:execution_result][:exception]
        render_section('Stack Trace', 1) do |doc|
          doc.pre {
            doc.text format_backtrace(exception.backtrace, example).join("\n")
          }
        end
      end

      def render_code(exception)
        backtrace = exception.backtrace.map {|line| backtrace_line(line)}
        backtrace.compact!
        @snippet_extractor ||= ::RSpec::Core::Formatters::SnippetExtractor.new
        "<pre class=\"ruby\"><code>#{@snippet_extractor.snippet(backtrace)}</code></pre>"
      end

      def render_section(title, panel_number)
        build_fragment do |doc|
          doc.section {
            doc.p(class: 'title', 'data-section-title' => '') {
              doc.a(href: "#panel#{panel_number}") { doc.text title }
            }
            doc.div(class: 'content', 'data-section-content' => '') {
              yield doc
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



