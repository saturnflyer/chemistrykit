# Encoding: utf-8

require 'yaml'
require 'ostruct'

require 'chemistrykit/config/basic_auth'
require 'chemistrykit/config/split_testing'

module ChemistryKit
  # Default configuration class
  class Configuration

    attr_accessor :base_url,
                  :concurrency,
                  :screenshot_on_fail,
                  :retries_on_failure

    attr_reader   :log, :basic_auth, :split_testing

    attr_writer   :selenium_connect

    def initialize(hash)
      # set defaults
      @concurrency = 1
      @retries_on_failure = 1
      @selenium_connect = {}
      @screenshot_on_fail = false
      @log = OpenStruct.new
      @log.path = 'evidence'
      @log.results_file = 'results_junit.xml'
      @log.format = 'ChemistryKit::RSpec::JUnitFormatter'
      @basic_auth = nil
      @split_testing = nil

      # overide with argument
      populate_with_hash hash
    end

    def log=(log_hash)
      log_hash.each do |key, value|
        value = 'ChemistryKit::RSpec::JUnitFormatter' if key == :format && value =~ /junit/i
        @log.send("#{key}=", value) unless value.nil?
      end
    end

    def basic_auth=(basic_auth_hash)
      @basic_auth = ChemistryKit::Config::BasicAuth.new(basic_auth_hash.merge(base_url: base_url))
    end

    def split_testing=(split_testing_hash)
      @split_testing = ChemistryKit::Config::SplitTesting.new(split_testing_hash)
    end

    def selenium_connect
      # return the default log unless the sc log is set
      if @selenium_connect[:log].nil?
        @selenium_connect[:log] = @log.path
        return @selenium_connect
      end
      @selenium_connect
    end

    def self.initialize_with_yaml(file)
      new symbolize_keys YAML.load_file file
    end

    private

      def populate_with_hash(hash)
        hash.each do |key, value|
          begin
            send "#{key}=", value unless value.nil?
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
