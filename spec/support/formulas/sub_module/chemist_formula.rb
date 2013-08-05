# Encoding: utf-8

require 'chemistrykit/formula/base'
require 'chemistrykit/formula/chemist_aware'

module Formulas
  module SubModule
    class ChemistFormula < ChemistryKit::Formula::Base
      include ChemistryKit::Formula::ChemistAware
      def open(url)
        @driver.get url
      end
    end
  end
end
