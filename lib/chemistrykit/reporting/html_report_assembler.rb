# Encoding: utf-8

require 'nokogiri'

module ChemistryKit
  module Reporting
    class HtmlReportAssembler

      def initialize(results_path, output_file)
        @results_path = results_path
        @output_file = output_file
        @groups = []
      end

      def assemble
        result_files = Dir.glob(File.join(@results_path, 'results_*.html'))

        result_files.each do |file|
          doc = Nokogiri::HTML(open(file))
          doc.css('.group').each do |group|
            @groups << group
          end
        end

        File.open(@output_file, 'w') do |file|

          file.write "<h1>this cool</h1>"

          @groups.each do |group|
            file.write group
          end

          file.write "<h1>footer yo</h1>"

        end

      end
    end
  end
end
