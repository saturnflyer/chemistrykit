require 'chemistrykit/sauce'
require 'rspec/core/shared_context'
require 'restclient'
require File.join(Dir.getwd, '_config', 'requires')

module ChemistryKit
  module SharedContext
    extend RSpec::Core::SharedContext
    include ChemistryKit::Sauce

    attr_accessor :magic_keys, :example_tags, :payload, :executor

    def capabilities
      Selenium::WebDriver::Remote::Capabilities.send(CHEMISTRY_CONFIG['webdriver']['browser'])
    end

    def driver(an_executor, capabilities)
      if CHEMISTRY_CONFIG['chemistrykit']['run_locally']
        @driver = Selenium::WebDriver.for(CHEMISTRY_CONFIG['webdriver']['browser'].to_sym)
      else
        puts "remote"
        @driver = ChemistryKit::WebDriver::Driver.new(:url => an_executor, :desired_capabilities => capabilities)
      end
    end

    def selenium_server_executor
      @executor = 'http://' + CHEMISTRY_CONFIG['webdriver']['server_host'] + ":" + CHEMISTRY_CONFIG['webdriver']['server_port'].to_s + '/wd/hub'
    end

    def choose_executor
      if CHEMISTRY_CONFIG['saucelabs']['ondemand']
        sauce_executor
      else
        selenium_server_executor
      end
    end

    before(:each) do
      if CHEMISTRY_CONFIG['saucelabs']['ondemand']
        if CHEMISTRY_CONFIG['webdriver']['browser'] != 'chrome'
          capabilities[:version] = CHEMISTRY_CONFIG['saucelabs']['version']
        else
          capabilities[:platform] = CHEMISTRY_CONFIG['saucelabs']['platform']
        end
        set_sauce_keys
        choose_executor
        driver(@executor, capabilities)
      else
        executor
        driver(@executor, capabilities)
      end
    end

    after(:each) do
      if CHEMISTRY_CONFIG['saucelabs']['ondemand']
        @session_id = @driver.session_id
        @driver.quit
        setup_data_for_sauce
        create_payload
        post_to_sauce
      else
        @driver.quit
      end
    end

  end
end
