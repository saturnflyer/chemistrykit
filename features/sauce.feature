@announce
Feature: Sauce specific feature tests

  Background:
    Given I run `bundle exec ckit new sauce-test`
    And I cd to "sauce-test"
    And a file named "beakers/first_beaker.rb" with:
    """
    describe "Sauce Beaker", :depth => 'shallow' do
      it "test" do
        @driver.get "http://www.google.com"
        @driver.title.should include("Google")
      end
    end
    """
    And I overwrite config.yaml with:
      """
      screenshot_on_fail: true
      selenium_connect:
          host: 'saucelabs'
          browser: 'firefox'
          sauce_username: 'testing_arrgyle'
          sauce_api_key: 'ab7a6e17-16df-42d2-9ef6-c8d2539cc38a'
          sauce_opts:
              public: 'private'
      """

  Scenario: Default permission config should work
    When I run `bundle exec ckit brew`
    Then the stdout should contain "1 example, 0 failures"
    And the file "evidence/sauce_beaker/sauce_beaker_test/sauce_job.log" should contain "private"

  Scenario: I can set a specific permission with a tag
    Given  I overwrite "beakers/first_beaker.rb" with:
    """
    describe "Sauce Beaker", :depth => 'shallow', :public => 'share', :crazy => 'test_tag' do
      it "test" do
        @driver.get "http://www.google.com"
        @driver.title.should include("Google")
      end
    end
    """
    When I run `bundle exec ckit brew`
    Then the stdout should contain "1 example, 0 failures"
    And the file "evidence/sauce_beaker/sauce_beaker_test/sauce_job.log" should contain "share"
    And the file "evidence/sauce_beaker/sauce_beaker_test/sauce_job.log" should contain "crazy:test_tag"
