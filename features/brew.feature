Feature: Brewing a ChemistryKit project

  Running `ckit brew` runs the suite of tests.

  There are four different ways to run ChemistryKit:
    1. Run on local selenium-webdriver
    2. Locally running selenium server
    3. Run on selenium server with Sauce Ondemand
    4. Run on selenium server with Sauce Ondemand with Chrome

  Background: Setup the project
    Given I run `ckit new booker`
    And a file named "booker/formulas/bookie.rb" with:
      """ruby
      module Formulas
        class Bookie
          def initialize(driver)
            @driver = driver
          end

          def open(url)
            @driver.get url
          end
        end
      end
      """
    And a file named "booker/beaker/bookie_beaker.rb" with:
      """ruby
      describe "Bookie", :depth => 'shallow' do
        let(:book) { Formulas::Bookie.new(@driver) }

        it "loads an external web page" do
          book.open "http://www.google.com"
        end
      end
      """
    And I cd to "booker"

  Scenario: Local webdriver
    Given a file named "booker/_config/chemistrykit.yaml" with:
    """yaml
    ---
    chemistrykit: {
      project: Booker
      capture_output: false,
      run_locally: true
    }

    webdriver: {
      browser: firefox,
      server_host: localhost,
      server_port: 4444
    }

    saucelabs: {
        ondemand: false,
        version: 18,
        platform: Windows 2008
    }
    """
    When I run `ckit brew`
    Then the stdout should contain "1 example, 0 failures"

  Scenario: Locally running selenium server
    Given a file named "booker/_config/chemistrykit.yaml" with:
    """yaml
    ---
    chemistrykit: {
      project: Booker
      capture_output: false,
      run_locally: false
    }

    webdriver: {
      browser: firefox,
      server_host: localhost,
      server_port: 4444
    }

    saucelabs: {
        ondemand: false,
        version: 18,
        platform: Windows 2008
    }
    """
    When I run `ckit brew`
    Then the stdout should contain "1 example, 0 failures"

  # Scenario: Selenium server with Sauce Ondemand
  #   Given a file named "booker/_config/chemistrykit.yaml" with:
  #   """yaml
  #   ---
  #   chemistrykit: {
  #     project: Booker
  #     capture_output: false,
  #     run_locally: false
  #   }

  #   webdriver: {
  #     browser: firefox,
  #     server_host: localhost,
  #     server_port: 4444
  #   }

  #   saucelabs: {
  #       ondemand: false,
  #       version: 18,
  #       platform: Windows 2008
  #   }
  #   """
  # Scenario: Selenium server with Sauce Ondemand with a chrome browser
  #   Given a file named "booker/_config/chemistrykit.yaml" with:
  #   """yaml
  #   ---
  #   chemistrykit: {
  #     project: <%= name.capitalize %>,
  #     capture_output: false,
  #     run_locally: true
  #   }

  #   webdriver: {
  #     browser: firefox,
  #     server_host: localhost,
  #     server_port: 4444
  #   }

  #   saucelabs: {
  #       ondemand: false,
  #       version: 18,
  #       platform: Windows 2008
  #   }
  #   """
