# Encoding: utf-8

require 'yaml'
require 'ostruct'

module ChemistryKit
  # Default configuration class
  class Configuration

    attr_accessor :base_url,
                  :concurrency,
                  :screenshot_on_fail,
                  :retries_on_failure

    attr_reader   :log

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
      @log.format = 'JUnit'

      # overide with argument
      populate_with_hash hash
    end

    def log=(log_hash)
      log_hash.each do |key, value|
        value = 'JUnit' if key == :format && value =~ /junit/i
        @log.send("#{key}=", value) unless value.nil?
      end
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
