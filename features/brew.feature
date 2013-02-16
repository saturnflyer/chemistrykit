Feature: Brewing a ChemistryKit project

  Running ckit brew runs the suite of tests.

  There are four different ways to run ChemistryKit:
    1. Locally on selenium-webdriver
    2. Selenium remote
    3. Selenium remote with Sauce Ondemand
    4. Selenium remote with Sauce Ondemand with Sauce Ondemand with Chrome

  Background: Setup the project
    Given I run `ckit new booker`
    And I cd to "booker"
    And a file named "formulas/bookie.rb" with:
      """
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
    And a file named "beaker/bookie_beaker.rb" with:
      """
      describe "Bookie", :depth => 'shallow' do
        let(:book) { Formulas::Bookie.new(@driver) }

        it "loads an external web page" do
          book.open "http://www.google.com"
        end
      end
      """
    And a file named "_config/saucelabs.yaml" with:
    """yaml
    ---
    username: testing_arrgyle
    key: ab7a6e17-16df-42d2-9ef6-c8d2539cc38a
    """

  Scenario Outline: All The Things
    When I overwrite _config/chemistrykit.yaml with:
      """
      chemistrykit: {
        project: Booker,
        capture_output: false,
        run_locally: <%= <local?> %>
        }

      webdriver: {
        browser: firefox,
        server_host: localhost,
        server_port: 4444
        }

      saucelabs: {
          ondemand: <%= <on_demand?> %>,
          version: 18,
          platform: Windows 2008
          }
      """
    When I run `ckit brew`
    Then the stdout should contain "1 example, 0 failures"
  
  Examples:
  | description         | local?  | on_demand?  | browser |
  | #Local Gem Driver   | true    | false       | firefox |
#  | #Standalone Server  | false   | false       | firefox |
  | #Sauce On Demand    | false   | true        | firefox |
#  | #Sauce On Demand    | false   | true        | chrome  |
