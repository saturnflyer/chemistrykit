Feature: Brewing a ChemistryKit project

  Background: Setup the project
    Given I run `bundle exec ckit new chemists-test`
    And I cd to "chemists-test"
    And a file named "chemists/chemists.csv" with:
      """
      Key,Type,Email,Name,Password
      admin1,admin,admin@email.com,Mr. Admin,abc123$
      normal1,normal,normal@email.com,Ms. Normal,test123%
      ran1,random,normal@email.com,Ms. Normal,test123%
      ran2,random,normal@email.com,Ms. Normal,test123%
      """
    And I overwrite config.yaml with:
      """
      screenshot_on_fail: true
      selenium_connect:
          browser: 'firefox'
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
    And a file named "formulas/advanced_chemist_formula.rb" with:
      """
      module Formulas
        class AdvancedChemistFormula < Formula
          include ChemistryKit::Formula::ChemistAware
          def open(url)
            @driver.get url
          end

          def search
            search_box = find id: 'gbqfq'
            search_box.send_keys chemist.some_sub_account.item
            search_box.send_keys :enter
          end

          def search_results_found?
            wait_for(5) { displayed? id: 'search' }
            search_results = find id: 'search'
            search_results.text.include?(chemist.some_sub_account.item)
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

          def find(locater)
            @driver.find_element locater
          end

          def displayed?(locater)
            begin
              find(locater).displayed?
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
    When I run `bundle exec ckit brew`
    Then the stdout should contain "1 example, 0 failures"

  Scenario: Chemist formula loading with formula_lab
    Given a file named "beakers/chemist_beaker.rb" with:
      """
      describe "Chemist Beaker", :depth => 'shallow' do
        let(:chem) { @formula_lab.using('chemist_formula').with('admin1').mix }

        it "loads an external web page" do
          chem.open "http://www.google.com"
          chem.search
          chem.search_results_found?.should eq true
        end
      end
      """
    When I run `bundle exec ckit brew`
    Then the stdout should contain "1 example, 0 failures"

  Scenario: Loading multiple formulas in a beaker
    Given a file named "beakers/chemist_beaker.rb" with:
      """
      describe "Chemist Beaker", :depth => 'shallow' do
        let(:basic) { @formula_lab.mix('basic_formula') }
        let(:chem) { @formula_lab.using('chemist_formula').with('admin1').mix }
        let(:chem2) { @formula_lab.using('chemist_formula').with('other1').mix }

        it "loads an external web page" do
          basic.open "http://www.google.com"
          chem.search
          chem.search_results_found?.should eq true
        end

        it "loads an external web page" do
          basic.open "http://www.google.com"
          chem2.search
          chem2.search_results_found?.should eq true
        end
      end
      """
    And a file named "chemists/others.csv" with:
      """
      Key,Type,Email,Name,Password
      other1,other,other@email.com,Mr. Other,abc123$
      """
    When I run `bundle exec ckit brew`
    Then the stdout should contain "2 examples, 0 failures"

  @announce
  Scenario: Composing a chemist from multiple files
    Given a file named "beakers/chemist_beaker.rb" with:
      """
      describe "Chemist Beaker", :depth => 'shallow' do
        let(:basic) { @formula_lab.mix('basic_formula') }
        let(:chem) { @formula_lab.using('advanced_chemist_formula').with('admin1').and_with('other1').mix }
        it "loads an external web page" do
          basic.open "http://www.google.com"
          chem.search
          chem.search_results_found?.should eq true
        end
      end
      """
    And a file named "chemists/others.csv" with:
      """
      Key,Type,Item
      other1,some_sub_account,some
      """
    When I run `bundle exec ckit brew`
    Then the stdout should contain "1 example, 0 failures"
