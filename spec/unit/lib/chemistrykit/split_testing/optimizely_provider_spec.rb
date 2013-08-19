# Encoding: utf-8

require 'spec_helper'
require 'chemistrykit/split_testing/optimizely_provider'

describe ChemistryKit::SplitTesting::OptimizelyProvider do

  before(:each) do
    @config = double 'ChemistryKit::Config::SplitTesting'
    @provider = ChemistryKit::SplitTesting::OptimizelyProvider.new(@config)
  end

  it 'should be initialized with the split testing config object' do
    @provider.should be_an_instance_of ChemistryKit::SplitTesting::OptimizelyProvider
  end

  it 'should respond to config' do
    @config.should_receive :provider
    @provider.should respond_to :config
    @provider.config.provider
  end

  it 'should set the cookie correctly on split' do

    @config.should_receive :base_url
    @config.should_receive(:opt_out?).and_return(true)

    driver = double 'Selenium::WebDriver::Driver'
    driver.should_receive(:get)

    manage = double 'manage'
    manage.should_receive(:add_cookie)
    driver.should_receive(:manage).and_return(manage)

    navigate = double 'navigate'
    navigate.should_receive(:refresh)
    driver.should_receive(:navigate).and_return(navigate)

    @provider.split(driver)

  end
end
