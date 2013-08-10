Feature: Advanced HTML Reports
  In order to quickly know the status of the application
  As a chemistry kit harness user
  I want a detailed HTML report of failures

  Background:
    Given I run `ckit new reporting-test`
    And I cd to "reporting-test"
    And a file named "beakers/first_beaker.rb" with:
    """
    describe "Reporting Beaker 1", :depth => 'shallow' do
      it "loads an external web page, from 1" do
        @driver.get "http://www.google.com"
        @driver.title.should include("Yoogle")
      end
    end
    """
    And a file named "beakers/second_beaker.rb" with:
    """
    describe "Reporting Beaker 2", :depth => 'shallow' do
      it "loads an external web page, from 2" do
        @driver.get "http://www.google.com"
        @driver.title.should include("Yoogle")
      end
    end
    """
    And I overwrite config.yaml with:
      """
      selenium_connect:
          log: 'evidence'
          browser: chrome
      concurrency: 4
      """

  @announce
  Scenario: I can run the tests in parallel
    When I run `ckit brew`
    Then the stdout should contain "4 processes for 2 beakers"
    And the stdout should contain "2 examples, 2 failures"
