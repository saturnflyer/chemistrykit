@announce
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
      it "loads an external web page, from 1, example 1" do
        @driver.get "http://www.google.com"
        @driver.title.should include("Yoogle")
      end
      it 'something pending' do
        pending 'this should be pending'
      end
      it "loads an external web page, from 1, example 2" do
        @driver.get "http://www.google.com"
        @driver.title.should include("Google")
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
    And a file named "beakers/third_beaker.rb" with:
    """
    describe "Reporting Beaker 3", :depth => 'shallow' do
      it "loads an external web page, from 3" do
        @driver.get "http://www.google.com"
        @driver.title.should include("Yoogle")
      end
    end
    """
    And I overwrite config.yaml with:
      """
      screenshot_on_fail: true
      selenium_connect:
          browser: 'firefox'
      """

  Scenario: I can run the tests
    When I run `ckit brew`
    Then the stdout should contain "5 examples, 3 failures, 1 pending"
    And the following files should exist:
      | evidence/final_results.html |

  Scenario: I can run the tests local with  concurrency
    Given I overwrite config.yaml with:
      """
      concurrency: 2
      screenshot_on_fail: true
      selenium_connect:
          browser: 'chrome'
      """
    When I run `ckit brew`
    Then the stdout should contain "5 examples, 3 failures, 1 pending"
    And the following files should exist:
      | evidence/final_results.html |

  Scenario: I can run the tests with concurrency
    Given I overwrite config.yaml with:
      """
      concurrency: 2
      screenshot_on_fail: true
      selenium_connect:
          host: 'saucelabs'
          browser: 'firefox'
          sauce_username: 'testing_arrgyle'
          sauce_api_key: 'ab7a6e17-16df-42d2-9ef6-c8d2539cc38a'
          description: 'concurrency check'
      """
    When I run `ckit brew`
    Then the stdout should contain "2 processes for 3 beakers"
    And the following files should exist:
      | evidence/final_results.html |

  Scenario: I can run a passing suite
  Given a file named "beakers/fourth_beaker.rb" with:
    """
    describe "Reporting Beaker 4", :depth => 'shallow' do
      it "loads an external web page, from 4" do
        @driver.get "http://www.google.com"
        @driver.title.should include("Google")
      end
    end
    """
  When I run `ckit brew --beakers=beakers/fourth_beaker.rb`
  And the following files should exist:
      | evidence/final_results.html |

Scenario: I capture the dom from all open windows
Given a file named "beakers/fifth_beaker.rb" with:
  """
    describe "Reporting Beaker 5", :depth => 'shallow' do
      it "loads two windows, from 5" do
        @driver.get 'http://the-internet.herokuapp.com/windows'
        @driver.find_element(css: '.example a').click
        @driver.title.should include("Google")
      end
    end
  """
  When I run `ckit brew --beakers=beakers/fifth_beaker.rb`
  And the following files should exist:
      | evidence/final_results.html |

