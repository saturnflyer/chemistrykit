@announce
Feature: Listing all the tags
  In order to see all the tags I'm using
  As a harness developer
  I want to run a command to list all the tags

  Background: Setup the project
    Given I run `bundle exec ckit new tags-test`
    And I cd to "tags-test"

  Scenario: Get the tag for a single beaker
    Given a file named "beakers/bookie_beaker.rb" with:
      """
      describe "Bookie", :depth => 'shallow' do
        let(:book) { Formulas::Bookie.new(@driver) }

        it "loads an external web page" do
          book.open "http://www.google.com"
        end
      end
      """
    When I run `bundle exec ckit tags`
    Then the stdout should contain "depth:shallow"

  Scenario: Get the tags inside a beaker
    Given a file named "beakers/bookie_beaker.rb" with:
      """
      describe "Bookie" do
        let(:book) { Formulas::Bookie.new(@driver) }

        it "loads an external web page", :depth => 'shallow' do
          book.open "http://www.google.com"
        end
        it "loads an external web page", :depth => 'deep' do
          book.open "http://www.google.com"
        end
      end
      """
    When I run `bundle exec ckit tags`
    Then the stdout should contain "depth:shallow"
    And the stdout should contain "depth:deep"

  Scenario: The tags should be unique and in alpha order
    Given a file named "beakers/bookie_beaker.rb" with:
      """
      describe "Bookie" do
        let(:book) { Formulas::Bookie.new(@driver) }

        it "loads an external web page", :aaa => 'ccc' do
          book.open "http://www.google.com"
        end
        it "loads an external web page", :bbb => 'ddd' do
          book.open "http://www.google.com"
        end
      end
      """
    And a file named "beakers/bookie_other.rb" with:
      """
      describe "Other", :depth => 'shallow' do
        let(:book) { Formulas::Bookie.new(@driver) }

        it "loads an external web page", :bbb => 'aaa' do
          book.open "http://www.google.com"
        end
        it "loads an external web page", :aaa => 'ccc' do
          book.open "http://www.google.com"
        end
      end
      """
    When I run `bundle exec ckit tags`
    Then the stdout from "bundle exec ckit tags" should contain:
      """
      ....
      Tags used in harness:

      aaa:ccc
      bbb:aaa
      bbb:ddd
      depth:shallow


      Finished
      """
