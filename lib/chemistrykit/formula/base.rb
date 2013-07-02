# Encoding: utf-8

module ChemistryKit
  module Formula
    # Base functionality for the Formula class
    class Base

      attr_accessor :catalyst

      def initialize(driver)
        @driver = driver
      end

      def catalyze(path_to_file)
        self.catalyst = ChemistryKit::Catalyst.new(path_to_file)
      end

    end # Base
  end # Formula
end # ChemistryKit
