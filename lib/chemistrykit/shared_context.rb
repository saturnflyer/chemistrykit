require 'chemistrykit/sauce'
require 'rspec/core/shared_context'
require 'restclient'
require File.join(Dir.getwd, '_config', 'requires')

module ChemistryKit
  module SharedContext
    extend RSpec::Core::SharedContext
    include ChemistryKit::Sauce

    attr_accessor :magic_keys, :example_tags, :payload

    # This needs to be tested
    def choose_executor
      puts "choosing executor"
      if CHEMISTRY_CONFIG['saucelabs']['ondemand']
        puts "Chose sauce executor"
        @executor = sauce_executor
      else
        puts "Chose selenium server executor"
        @executor = 'http://' + CHEMISTRY_CONFIG['webdriver']['server_host'] + ":" + CHEMISTRY_CONFIG['webdriver']['server_port'].to_s + '/wd/hub'
      end
    end

    def capabilities
      puts "defining capabilities"
      Selenium::WebDriver::Remote::Capabilities.send(CHEMISTRY_CONFIG['webdriver']['browser'])
    end

    def driver(an_executor, capabilities)
      puts "setting driver"
      if CHEMISTRY_CONFIG['chemistrykit']['run_locally']
        puts "chose local driver"
        @driver = Selenium::WebDriver.for(CHEMISTRY_CONFIG['webdriver']['browser'].to_sym)
      else
        puts "chose selenium remote driver"
        @driver = ChemistryKit::WebDriver::Driver.new(:url => an_executor, :desired_capabilities => capabilities)
      end
    end

    before(:all) do
      puts "setting up global configs"
      if CHEMISTRY_CONFIG['saucelabs']['ondemand']
        puts "choosing capabilities of browser"
        if CHEMISTRY_CONFIG['webdriver']['browser'] != 'chrome'
          puts "chose non-chrome browser"
          capabilities[:version] = CHEMISTRY_CONFIG['saucelabs']['version']
        else
          puts "chose chrome browser"
          capabilities[:platform] = CHEMISTRY_CONFIG['saucelabs']['platform']
        end
        puts "Setting up sauce keys"
        set_sauce_keys
      end
      choose_executor
    end

    before(:each) do
      puts "creating the driver"
      driver(@executor, capabilities)
    end

    after(:each) do
      puts "shutting things down"
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
