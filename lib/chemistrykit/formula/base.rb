module ChemistryKit
  module Formula
    class Base

      def initialize(driver)
        @driver = driver
      end

      def catalyst=(path_to_file)
        @catalyst = ChemistryKit::Catalyst.new(path_to_file)
      end

      def catalyst
        @catalyst
      end

    end #Base
  end #Formula
end #ChemistryKit
