Feature: opting out of ab tests based on configuration

Background:
    Given I run `bundle exec ckit new split-test`
    And I cd to "split-test"
    And a file named "beakers/first_beaker.rb" with:
    """
    describe "Split test beaker", :depth => 'shallow' do
      it "would not hit the ab testing end point" do
          @driver.get 'http://the-internet.herokuapp.com/abtest'
          @driver.find_element(css: 'h3').text.should == 'No A/B Test'
      end
    end
    """
    And I overwrite config.yaml with:
      """
      screenshot_on_fail: true
      base_url: 'http://the-internet.herokuapp.com/abtest'
      selenium_connect:
          browser: 'firefox'
      split_testing:
        provider: 'optimizely'
        opt_out: true
      """

  Scenario: opt out is on
    When I run `bundle exec ckit brew`
    Then the stdout should contain "1 example, 0 failures"
