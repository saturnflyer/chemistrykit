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
    And I overwrite config.yaml with:
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

  Scenario: I can run the tests in parallel
    When I run `ckit brew`
    Then the stdout should contain "4 processes for 2 beakers"
    And the stdout should contain "3 examples, 0 failures"
    And the file "evidence/results_junit.xml" should not exist
    And there should be "2" unique results files in the "evidence" directory

  Scenario: I can run a specific beaker in parallel
    When I run `ckit brew --beakers=beakers/first_beaker.rb`
    Then the stdout should contain "4 processes for 1 beakers"
    And the stdout should contain "2 examples, 0 failures"

  Scenario: I can run specific beakers by tag in parallel
    Given a file named "beakers/tagged_beaker_1.rb" with:
      """
      describe "Cheese 3", :item => 'test' do
        it "loads an external web page" do
          @driver.get "http://www.google.com"
          @driver.title.should include("Google")
        end
      end
      """
    And a file named "beakers/tagged_beaker_2.rb" with:
      """
      describe "Cheese 4", :item => 'test' do
        it "loads an external web page" do
          @driver.get "http://www.google.com"
          @driver.title.should include("Google")
        end
      end
      """
    When I run `ckit brew --tag item:test`
    And the stdout should contain "2 examples, 0 failures"

    Scenario: I can all beakers in parallel
    Given a file named "beakers/tagged_beaker_1.rb" with:
      """
      describe "Cheese 3", :item => 'test' do
        it "loads an external web page" do
          @driver.get "http://www.google.com"
          @driver.title.should include("Google")
        end
      end
      """
    And a file named "beakers/tagged_beaker_2.rb" with:
      """
      describe "Cheese 4", :item => 'test' do
        it "loads an external web page" do
          @driver.get "http://www.google.com"
          @driver.title.should include("Google")
        end
      end
      """
    When I run `ckit brew --all`
    Then the stdout should not contain "All examples were filtered out"
    And the stdout should not contain "0 examples, 0 failures"
    And there should be "4" unique results files in the "evidence" directory
    And there should be "2" "report" log files in "evidence/cheese"
