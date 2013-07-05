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

  Scenario: I can output junit xml results
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
    Then the following files should exist:
      | my_evidence/my_results.xml  |

