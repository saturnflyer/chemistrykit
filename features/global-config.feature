Feature: Initialize a global configuration
  In order to configure chemistrykit
  As a chemistry kit harness developer
  I want to specify configurations in a central file so they are available in test scripts

  Scenario: Use a configuration option in a beaker
    Given I run `ckit new global-config-test`
    And I cd to "global-config-test"
    And a file named "beaker/test_beaker.rb" with:
    """
    describe "Cheese", :depth => 'shallow' do
      it "loads an external web page" do
        @driver.get @config.base_url
        @driver.title.should include("Google")
      end
    end
    """
    And I overwrite config.yaml with:
    """
    base_url: http://www.google.com
    selenium_connect:
        log: 'evidence'
        host: 'localhost'
    """
    When I run `ckit brew`
    Then the stdout should contain "1 example, 0 failures"
