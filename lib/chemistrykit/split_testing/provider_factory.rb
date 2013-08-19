# Encoding: utf-8

require 'chemistrykit/split_testing/optimizely_provider'

module ChemistryKit
  module SplitTesting
    class ProviderFactory
      def self.build(config)
        case config.provider
        when 'optimizely'
          ChemistryKit::SplitTesting::OptimizelyProvider.new(config)
        else
          raise ArgumentError.new "The provider: \"#{config.provider}\" is unknown!"
        end
      end
    end
  end
end
