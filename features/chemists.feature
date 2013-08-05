Feature: Brewing a ChemistryKit project

  Background: Setup the project
    Given I run `ckit new chemists-test`
    And I cd to "chemists-test"
    And a file named "chemists/chemists.csv" with:
      """
      Key,Type,Email,Name,Password
      admin1,admin,admin@email.com,Mr. Admin,abc123$
      normal1,normal,normal@email.com,Ms. Normal,test123%
      ran1,random,normal@email.com,Ms. Normal,test123%
      ran2,random,normal@email.com,Ms. Normal,test123%
      """
    And a file named "formulas/basic_formula.rb" with:
      """
      module Formulas
        class BasicFormula < Formula
          def open(url)
            @driver.get url
          end
        end
      end
      """
    And a file named "formulas/chemist_formula.rb" with:
      """
      require 'chemistrykit/formula/chemist_aware'

      module Formulas
        class ChemistFormula < Formula
          include ChemistryKit::Formula::ChemistAware
          def open(url)
            @driver.get url
          end

          def search
            search_box = find id: 'gbqfq'
            search_box.send_keys chemist.type
            search_box.send_keys :enter
          end

          def search_results_found?
            wait_for(5) { displayed? id: 'search' }
            search_results = find id: 'search'
            search_results.text.include?(chemist.type)
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

  @announce
  Scenario: Simple formula loading with formula_lab
    Given a file named "beakers/chemist_beaker.rb" with:
      """
      describe "Chemist Beaker", :depth => 'shallow' do
        let(:basic) { @formula_lab.mix('basic_formula') }

        it "loads an external web page" do
          basic.open "http://www.google.com"
        end
      end
      """
    When I run `ckit brew`
    Then the stdout should contain "1 example, 0 failures"

  @announce
  Scenario: Chemist formula loading with formula_lab
    Given a file named "beakers/chemist_beaker.rb" with:
      """
      describe "Chemist Beaker", :depth => 'shallow' do
        let(:basic) { @formula_lab.using('chemist_formula').with('admin1').mix }

        it "loads an external web page" do
          basic.open "http://www.google.com"
          basic.search
          basic.search_results_found?.should eq true
        end
      end
      """
    When I run `ckit brew`
    Then the stdout should contain "1 example, 0 failures"
