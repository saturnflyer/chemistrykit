Feature: Catalyst
Catalyst: n. A pocket of data (consumed from a CSV file) used to drive a test that needs it.

  Scenario: Use a catalyst value to drive a test
    Given I run `ckit new catalyst-example`
    And I cd to "catalyst-example"

    And a file named "formulas/lib/catalysts/google_test_data.csv" with:
    """
    url,http://www.google.com
    search_query,Flying Elephants
    """

    And a file named "formulas/google.rb" with:
      """
      module Formulas
        class Google < Formula

          def visit
            open catalyst.url
          end

          def search
            search_box = find id: 'gbqfq'
            search_box.send_keys catalyst.search_query
            search_box.send_keys :enter
          end

          def search_results_found?
            wait_for(5) { displayed? id: 'search' }
            search_results = find id: 'search'
            search_results.text.include?(catalyst.search_query)
          end

        end
      end
      """

    And a file named "formulas/lib/formula.rb" with:
      """
      module Formulas
        class Formula < ChemistryKit::Formula::Base

          def open(url)
            @driver.get url
          end

          def find(locator)
            @driver.find_element locator
          end

          def displayed?(locator)
            begin
              find(locator).displayed?
            rescue
              false
            end
          end

          def wait_for(seconds=2)
            Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
          end
        end
      end
      """

    And a file named "beaker/google_beaker.rb" with:
      """
      describe "Google", :depth => 'shallow' do
        let(:google) { Formulas::Google.new(@driver) }

        it "loads an external web page" do
          google.catalyst = 'formulas/lib/catalysts/google_test_data.csv'
          google.visit
          google.search
          google.search_results_found?.should eq true
        end
      end
      """

    And a file named "config.yaml" with:
      """
      jar: '../../../vendor/selenium-server-standalone-2.33.0.jar'
      log: 'evidence'
      host: 'localhost'
      """
    When I run `ckit brew`
    Then the stdout should contain "1 example, 0 failures"
