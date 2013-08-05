# Encoding: utf-8

require 'chemistrykit/formula/base'

module Formulas
  module SubModule
    class BasicFormula < ChemistryKit::Formula::Base
      def open(url)
        @driver.get url
      end
    end
  end
end
