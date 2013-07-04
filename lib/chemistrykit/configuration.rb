# Encoding: utf-8

require 'yaml'

module ChemistryKit
  # Default configuration class
  class Configuration

    attr_accessor :concurrency,
                  :base_url,
                  :selenium_connect

    def initialize(hash)
      # set defaults
      @concurrency = 1

      # overide with argument
      populate_with_hash hash
      validate_config
    end

    def self.initialize_with_yaml(file)
      self.new symbolize_keys YAML.load_file file
    end

    private

      def populate_with_hash(hash)
        hash.each do |key, value|
          begin
            self.send "#{key}=", value unless value.nil?
          rescue NoMethodError
            raise ArgumentError.new "The config key: \"#{key}\" is unknown!"
          end
        end
      end

      def validate_config
        if @selenium_connect && @selenium_connect[:host] != 'saucelabs' && @concurrency > 1
          raise ArgumentError.new 'Concurrency is only supported for the host: "saucelabs"!'
        end
      end

      # private static to symbolize recursivly a loaded yaml
      def self.symbolize_keys(hash)
        hash.reduce({}) do |result, (key, value)|
          new_key = key.class == String ? key.to_sym : key
          new_value = value.class == Hash ? symbolize_keys(value) : value
          result[new_key] = new_value
          result
        end
      end
  end
end
