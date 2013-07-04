Feature: Exit Status

  Background:
    Given I run `ckit new cheese`
    And I cd to "cheese"
    And a file named "config.yaml" with:
      """
      selenium_connect:
          log: 'evidence'
          host: 'localhost'
      """

  Scenario: Passing
    And a file named "beakers/test_beaker.rb" with:
    """
    describe "Cheese", :depth => 'shallow' do
      it "loads an external web page" do
        @driver.get "http://www.google.com"
        @driver.title.should include("Google")
      end
    end
    """
    When I run `ckit brew`
    Then the exit code should be 0

  Scenario: Failing
    And a file named "beakers/test_beaker.rb" with:
    """
    describe "Cheese", :depth => 'shallow' do
      it "loads an external web page" do
        @driver.get "http://www.google.com"
        @driver.title.should_not include("Google")
      end
    end
    """
    When I run `ckit brew`
    Then the exit code should be 1
