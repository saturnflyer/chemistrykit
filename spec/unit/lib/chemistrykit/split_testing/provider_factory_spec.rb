# Encoding: utf-8

require 'spec_helper'
require 'chemistrykit/split_testing/provider_factory'

describe ChemistryKit::SplitTesting::ProviderFactory do

  let(:config) { double 'ChemistryKit::Config::SplitTesting' }

  it 'should determine what kind of provider to build' do
    config.should_receive(:provider).and_return('optimizely')
    ChemistryKit::SplitTesting::ProviderFactory.build(config)
  end

  it 'should raise an error for an un known provider' do
    config.should_receive(:provider).twice.and_return('bad')
    expect do
      ChemistryKit::SplitTesting::ProviderFactory.build(config)
    end.to raise_error(ArgumentError, 'The provider: "bad" is unknown!')
  end

end
