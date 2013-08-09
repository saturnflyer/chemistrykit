# Encoding: utf-8
require 'rspec/core/formatters/html_formatter'

module ChemistryKit
  module RSpec
    class HtmlFormatter < ::RSpec::Core::Formatters::HtmlFormatter
      def extra_failure_content(exception)
        "<h1>Ya'll know we be failing.</h1>"
      end
    end
  end
end



