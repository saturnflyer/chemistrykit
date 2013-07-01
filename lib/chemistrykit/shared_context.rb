require 'rspec/core/shared_context'
require 'selenium-connect'
require 'yaml'

module ChemistryKit
  module SharedContext
    extend RSpec::Core::SharedContext

      config_file = File.join(Dir.getwd, ENV['CONFIG_FILE'])

      config_options = YAML.load_file(config_file)

      if config_options["base_url"]
        ENV['BASE_URL'] = config_options["base_url"]
      end

      SeleniumConnect.configure do |c|
        c.config_file = config_file
      end

      before(:each) do
        @driver = SeleniumConnect.start
      end

      after(:each) do
        @driver.quit
      end

      after(:all) do
        SeleniumConnect.finish
      end

  end #SharedContext
end #ChemistryKit
