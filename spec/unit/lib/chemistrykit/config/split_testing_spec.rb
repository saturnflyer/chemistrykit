# Encoding: utf-8

require 'spec_helper'
require 'chemistrykit/config/split_testing'

describe ChemistryKit::Config::SplitTesting do

  VALID_PROVIDER = 'optimizely'

  before(:each) do
    @opts = { provider: VALID_PROVIDER, opt_out: true, base_url: 'http://google.com'
      }
      @split_testing = ChemistryKit::Config::SplitTesting.new(@opts)
  end

  it 'should be initialized with an hash of options' do
    @split_testing.should be_an_instance_of ChemistryKit::Config::SplitTesting
  end

  it 'should get the basic configuration values' do
    @split_testing.provider.should eq VALID_PROVIDER
    @split_testing.base_url.should eq 'http://google.com'
    @split_testing.opt_out?.should be_true
  end

  it 'should raise an error for invalid config parameters' do
    expect do
      ChemistryKit::Config::SplitTesting.new(@opts.merge(bad: 'value'))
    end.to raise_error(ArgumentError, 'The config key: "bad" is unknown!')
  end
end
