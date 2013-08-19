# Encoding: utf-8

require 'spec_helper'
require 'chemistrykit/split_testing/provider_factory'
require 'chemistrykit/config/split_testing'

describe ChemistryKit::SplitTesting::ProviderFactory do

  it 'should return the correctly configured provider based on configuration' do
    config = ChemistryKit::Config::SplitTesting.new(provider: 'optimizely', opt_out: true)
    provider = ChemistryKit::SplitTesting::ProviderFactory.build(config)
    provider.should be_an_instance_of ChemistryKit::SplitTesting::OptimizelyProvider
  end

end
