# Encoding: utf-8

module ChemistryKit
  module Config
    class SplitTesting

      attr_accessor :provider

      attr_writer :opt_out

      def initialize(opts)
        opts.each do |key, value|
          begin
            send("#{key}=", value)
          rescue NoMethodError
            raise ArgumentError.new "The config key: \"#{key}\" is unknown!"
          end
        end
      end

      def opt_out?
        !!@opt_out
      end
    end
  end
end
