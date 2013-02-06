require 'rspec/core/shared_context'
require File.join(Dir.getwd, '_config', 'requires')
require 'restclient'

module ChemistryKit
  module SharedContext
    extend RSpec::Core::SharedContext

    def set_sauce_keys
      @magic_keys = [
      :caller,
      :description,
      :description_args,
      :example_group,
      :example_group_block,
      :execution_result,
      :file_path,
      :full_description,
      :line_number,
      :location
      ]
    end

    def capabilities
      capabilities = Selenium::WebDriver::Remote::Capabilities.send(CHEMISTRY_CONFIG['webdriver']['browser'])
    end

    def driver_for_server(executor, capabilities)
      @driver = ChemistryKit::WebDriver::Driver.new(:url => executor, :desired_capabilities => capabilities)
    end

    def driver_for_local
      @driver = Selenium::WebDriver.for(CHEMISTRY_CONFIG['webdriver']['browser'].to_sym)
    end

    def executor
      if CHEMISTRY_CONFIG['saucelabs']['ondemand']
        "http://#{SAUCE_CONFIG['username']}:#{SAUCE_CONFIG['key']}@ondemand.saucelabs.com:80/wd/hub"
      else
        'http://' + CHEMISTRY_CONFIG['webdriver']['server_host'] + ":" + CHEMISTRY_CONFIG['webdriver']['server_port'].to_s + '/wd/hub'
      end
    end

    def sauce_api_url
      "http://#{SAUCE_CONFIG['username']}:#{SAUCE_CONFIG['key']}@saucelabs.com:80/rest/v1/#{SAUCE_CONFIG['username']}/jobs/#{@session_id}"
    end

    def setup_data_for_sauce
      @example_tags = self.example.metadata.collect do |k, v|
        if not @magic_keys.include?(k)
          if v.to_s == 'true'
            k
          else
            "#{k}:#{v}"
          end
        end
      end
      @example_tags.compact!
    end

    def create_payload
      @payload = {
        :tags => @example_tags,
        :name => self.example.metadata[:full_description],
        :passed => self.example.exception ? false : true
      }
    end

    def post_to_sauce
      RestClient.put sauce_api_url, @payload.to_json, {:content_type => :json}
    end

    before(:each) do
      case # Three different options: selenium-webdriver, selenium server, and selenium server on Sauce
      when CHEMISTRY_CONFIG['chemistrykit']['run_locally']
        driver_for_local
      when CHEMISTRY_CONFIG['saucelabs']['ondemand']
        if CHEMISTRY_CONFIG['webdriver']['browser'] != 'chrome'
          capabilities[:version] = CHEMISTRY_CONFIG['saucelabs']['version']
        else
          capabilities[:platform] = CHEMISTRY_CONFIG['saucelabs']['platform']
        end
        set_sauce_keys
        executor
        driver_for_server(executor, capabilities)
      else
        executor
        driver_for_server(executor, capabilities)
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
