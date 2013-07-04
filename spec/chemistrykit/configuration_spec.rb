# Encoding: utf-8

require 'spec_helper'

describe ChemistryKit::Configuration do

  VALID_BASE_URL = 'http://google.com'
  VALID_CONCURRENCY = 1
  VALID_CONFIG_FILE = 'config.yaml'

  before(:each) do
    @valid_selenium_connect_hash = { log: 'evidence', host: 'localhost' }
    @valid_config_hash = {
      base_url: VALID_BASE_URL,
      concurrency: VALID_CONCURRENCY,
      selenium_connect: @valid_selenium_connect_hash
    }
  end

  def validate_config(config)
    config.concurrency.should eq VALID_CONCURRENCY
    config.base_url.should eq VALID_BASE_URL
    config.selenium_connect.should eq @valid_selenium_connect_hash
  end

  it 'should initialize with sane defaults' do
    config = ChemistryKit::Configuration.new({})
    config.concurrency.should eq 1
  end

  it 'should initialize with a hash of configurations' do
    validate_config ChemistryKit::Configuration.new(@valid_config_hash)
  end

  it 'can be initialized staticlly with a yaml file' do
    yaml_file = File.join(Dir.pwd, 'spec', 'support', VALID_CONFIG_FILE)
    validate_config ChemistryKit::Configuration.initialize_with_yaml yaml_file
  end

  it 'should throw an exception for unsupported config variable' do
    expect do
      ChemistryKit::Configuration.new bad: 'config-value'
    end.to raise_error ArgumentError, 'The config key: "bad" is unknown!'
  end

  it 'should throw an error if concurrency is configured and the host is not saucelabs' do
    expect do
      config_hash = {
      base_url: VALID_BASE_URL,
      concurrency: 2,
      selenium_connect: @valid_selenium_connect_hash
      }
      ChemistryKit::Configuration.new(config_hash)
    end.to raise_error ArgumentError, 'Concurrency is only supported for the host: "saucelabs"!'
  end
end
