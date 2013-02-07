Feature: ckit brew

  Running `ckit brew` runs the suite of tests.

  Background: Setup the project
    Given I run `ckit new booker`
    And a file named "booker/formulas/bookie.rb" with:
      """ruby
      module Formulas
        class Bookie
          def initialize(driver)
            @driver = driver
          end

          def open(url)
            @driver.get url
          end
        end
      end
      """
    And a file named "booker/beaker/bookie_beaker.rb" with:
      """ruby
      describe "Bookie", :depth => 'shallow' do
        let(:book) { Formulas::Bookie.new(@driver) }

        it "load an external web page" do
          book.open "http://www.google.com"
        end
      end
      """

  @announce
  Scenario: Returns true
    Given I cd to "booker"
    When I run `ckit brew`
#    When I execute `ckit brew`
    Then the stdout should contain "1 example, 0 failures"
