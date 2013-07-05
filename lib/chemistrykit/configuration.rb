# Encoding: utf-8

require 'yaml'
require 'ostruct'

module ChemistryKit
  # Default configuration class
  class Configuration

    attr_accessor :base_url

    attr_reader :concurrency,
                :log,
                :selenium_connect

    def initialize(hash)
      # set defaults
      @concurrency = 1
      @log = OpenStruct.new
      @log.path = 'evidence'
      @log.results_file = 'results_junit.xml'
      @log.format = 'JUnit'

      # overide with argument
      populate_with_hash hash
    end

    def log=(log_hash)
      log_hash.each do |key, value|
        if key == :format
          value = 'JUnit' if value =~ /junit/i
        end
        @log.send("#{key}=", value) unless value.nil?
      end
    end

    def concurrency=(value)
      if @selenium_connect && @selenium_connect[:host] != 'saucelabs' && value > 1
          raise ArgumentError.new 'Concurrency is only supported for the host: "saucelabs"!'
      end
      @concurrency = value
    end

    def selenium_connect=(selenium_connect_hash)
      if selenium_connect_hash[:host] != 'saucelabs' && @concurrency > 1
          raise ArgumentError.new 'Concurrency is only supported for the host: "saucelabs"!'
      end
      @selenium_connect = selenium_connect_hash
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
