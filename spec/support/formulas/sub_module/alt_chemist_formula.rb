# Encoding: utf-8

require 'chemistrykit/formula/base'
require 'chemistrykit/formula/chemist_aware'

module Formulas
  module SubModule
    class AltChemistFormula < ChemistryKit::Formula::Base
      include ChemistryKit::Formula::ChemistAware
      def open(url)
        @driver.get url
      end

      def change_chemist_type(type)
        chemist.type = type
      end
    end
  end
end
