# Encoding: utf-8

module ChemistryKit
  module Formula
    # Mixin to provide formulas with methods related to having a chemist (user)
    module ChemistAware
      attr_accessor :chemist
    end
  end
end
