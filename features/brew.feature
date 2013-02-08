Feature: Brewing a ChemistryKit project

  Running `ckit brew` runs the suite of tests.

  There are four different ways to run ChemistryKit:
    1. Run on local selenium-webdriver
    2. Run on selenium server
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

  Scenario: Local webdriver
    # Given I cd to "booker"
    # When I run `ckit brew`
    # Then the stdout should contain "1 example, 0 failures"
  Scenario: Selenium server
  Scenario: Selenium server with Sauce Ondemand
  Scenario: Selenium server with Sauce Ondemand with a chrome browser
