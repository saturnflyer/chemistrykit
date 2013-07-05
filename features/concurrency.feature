Feature: Support for concurency
  In order to run the tests quickly
  As a chemistry kit harness developer
  I want to run them in parallel

  Background:
    Given I run `ckit new concurrency-test`
    And I cd to "concurrency-test"
    And a file named "beakers/first_beaker.rb" with:
    """
    describe "Cheese", :depth => 'shallow' do
      it "loads an external web page" do
        @driver.get "http://www.google.com"
        @driver.title.should include("Google")
      end
      it "loads an external web page" do
        @driver.get "http://www.google.com"
        @driver.title.should include("Google")
      end
    end
    """
    And a file named "beakers/second_beaker.rb" with:
    """
    describe "Cheese 2", :depth => 'shallow' do
      it "loads an external web page" do
        @driver.get "http://www.google.com"
        @driver.title.should include("Google")
      end
    end
    """
  Scenario: I can run the tests in parallel
    When I overwrite config.yaml with:
      """
      concurrency: 4
      selenium_connect:
          log: 'evidence'
          host: 'saucelabs'
          browser: 'firefox'
          sauce_username: 'testing_arrgyle'
          sauce_api_key: 'ab7a6e17-16df-42d2-9ef6-c8d2539cc38a'
          description: 'concurrency check'
      """
    When I run `ckit brew`
    Then the stdout should contain "4 processes for 2 beakers"
    And the stdout should contain "3 examples, 0 failures"
    And the following files should exist:
      | evidence/parallel_part_1.xml  |
      | evidence/parallel_part_2.xml  |

  Scenario: I can run a specific beaker in parallel
    When I overwrite config.yaml with:
      """
      concurrency: 4
      selenium_connect:
          log: 'evidence'
          host: 'saucelabs'
          browser: 'firefox'
          sauce_username: 'testing_arrgyle'
          sauce_api_key: 'ab7a6e17-16df-42d2-9ef6-c8d2539cc38a'
          description: 'concurrency check'
      """
      When I run `ckit brew --beakers=beakers/first_beaker.rb`
      Then the stdout should contain "4 processes for 1 beakers"
      And the stdout should contain "2 examples, 0 failures"
