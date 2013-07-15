#logging.feature
Feature: Log handling
  In order to examine the results of my test suite
  As a test harness user
  I want to see all of the logs in a central location

  Background: Setup the project
    Given I run `ckit new logging-test`
    And I cd to "logging-test"
    And a file named "formulas/bookie.rb" with:
      """
      module Formulas
        class Bookie < Formula
          def open(url)
            @driver.get url
          end
        end
      end
      """
    And a file named "beakers/first_beaker.rb" with:
      """
      describe "First", :depth => 'shallow' do
        let(:book) { Formulas::Bookie.new(@driver) }

        it "loads an external web page" do
          book.open "http://www.google.com"
        end
      end
      """
    And a file named "beakers/second_beaker.rb" with:
      """
      describe "Second", :depth => 'shallow' do
        let(:book) { Formulas::Bookie.new(@driver) }

        it "loads an external web page" do
          book.open "http://www.google.com"
        end
      end
      """

  Scenario: I can output junit xml results by default
    When I run `ckit brew`
    Then the stdout should contain "2 examples, 0 failures"
    And the following files should exist:
      | evidence/results_junit.xml  |

  Scenario: I can output custom junit xml results
    Given a file named "config.yaml" with:
      """
      log:
          path: 'my_evidence'
          results_file: 'my_results.xml'
          format: 'junit'
      selenium_connect:
          log: 'evidence'
          host: 'localhost'
      """
    When I run `ckit brew`
    Then the stdout should contain "2 examples, 0 failures"
    And the following files should exist:
      | my_evidence/my_results.xml  |

    Scenario: I can output html results
      Given a file named "config.yaml" with:
        """
        log:
            results_file: 'report.html'
            format: 'html'
        """
      And I run `ckit brew`
      Then the stdout should contain "2 examples, 0 failures"
      And the following files should exist:
        | evidence/report.html  |

    Scenario: I define one log location to rule them all
      Given a file named "config.yaml" with:
        """
          log:
              path: 'my_evidence'
          selenium_connect:
              host: 'localhost'
        """
      When I run `ckit brew`
        Then the stdout should contain "2 examples, 0 failures"
        And the following files should exist:
          | my_evidence/results_junit.xml |
          | my_evidence/first/server.log  |
          | my_evidence/second/server.log  |

    Scenario: I can runtime override the results output file name
      When I run `ckit brew --results_file results_junit_01.xml`
      Then the stdout should contain "2 examples, 0 failures"
      And the following files should exist:
        | evidence/results_junit_01.xml  |

