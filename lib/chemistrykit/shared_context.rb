# Encoding: utf-8

require 'rspec/core/shared_context'
require 'selenium-connect'
require 'chemistrykit/configuration'
require 'yaml'

module ChemistryKit
  # Extends the Rspec Shared Context to include hooks for Selenium Connect
  module SharedContext
    extend RSpec::Core::SharedContext

      config_file = File.join(Dir.getwd, ENV['CONFIG_FILE'])
      config = ChemistryKit::Configuration.initialize_with_yaml config_file

      SeleniumConnect.configure do |c|
        c.populate_with_hash config.selenium_connect
      end

      before(:each) do
        @driver = SeleniumConnect.start
        @config = config
      end

      after(:each) do
        @driver.quit
      end

      after(:all) do
        SeleniumConnect.finish
      end

  end # SharedContext
end # ChemistryKit
