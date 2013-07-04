# Encoding: utf-8

require 'thor/group'

module ChemistryKit
  module CLI
    # Creates a starting formula from a template
    class FormulaGenerator < Thor::Group
      include Thor::Actions

      argument :name

      def self.source_root
        File.join(File.dirname(File.expand_path(__FILE__)), '../../templates/')
      end

      def copy_file
        template 'formula.tt', "./formulas/#{name}.rb"
        template 'beaker_with_formula.tt', "./beakers/#{name}_beaker.rb"
      end

    end
  end
end
