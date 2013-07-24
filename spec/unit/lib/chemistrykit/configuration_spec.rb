# Encoding: utf-8

require 'spec_helper'

describe ChemistryKit::Configuration do

  VALID_BASE_URL = 'http://google.com'
  VALID_CONCURRENCY = 1
  VALID_RETRIES_ON_FAILURE = 1
  VALID_CONFIG_FILE = 'config.yaml'
  VALID_LOG_PATH = 'evidence'
  VALID_JUNIT = 'results_junit.xml'
  VALID_FORMAT_JUNIT = 'junit'
  VALID_JUNIT_FORMAT_OUT = 'JUnit'

  before(:each) do
    @valid_selenium_connect_hash = { log: 'evidence', host: 'localhost' }
    @valid_log_hash = { path: VALID_LOG_PATH, results_file: VALID_JUNIT, format: VALID_FORMAT_JUNIT }
    @valid_config_hash = {
      base_url: VALID_BASE_URL,
      concurrency: VALID_CONCURRENCY,
      selenium_connect: @valid_selenium_connect_hash,
      log: @valid_log_hash,
      retries_on_failure: VALID_RETRIES_ON_FAILURE
    }
  end

  def validate_config(config)
    config.screenshot_on_fail.should eq false
    config.concurrency.should eq VALID_CONCURRENCY
    config.retries_on_failure.should eq VALID_RETRIES_ON_FAILURE
    config.base_url.should eq VALID_BASE_URL
    config.log.path.should eq VALID_LOG_PATH
    config.log.results_file.should eq VALID_JUNIT
    config.log.format.should eq VALID_JUNIT_FORMAT_OUT
    config.selenium_connect.should eq @valid_selenium_connect_hash
  end

  it 'should initialize with sane defaults' do
    config = ChemistryKit::Configuration.new({})
    config.concurrency.should eq VALID_CONCURRENCY
    config.retries_on_failure.should eq VALID_RETRIES_ON_FAILURE
    config.log.path.should eq VALID_LOG_PATH
    config.log.results_file.should eq VALID_JUNIT
    config.log.format.should eq VALID_JUNIT_FORMAT_OUT
    config.selenium_connect.should eq({ log: VALID_LOG_PATH })
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

  it 'should correct the format to JUnit' do
    config = ChemistryKit::Configuration.new(@valid_config_hash)
    config.log.format.should eq 'JUnit'
  end

  it 'selenium_connect log should default to the main log' do
    config =  ChemistryKit::Configuration.new({ log: { path: 'main-path' } })
    config.selenium_connect.should eq({ log: 'main-path' })
  end

  it 'mainlog should not overide selenium_connect log' do
    config =  ChemistryKit::Configuration.new({ log: { path: 'main-path' }, selenium_connect: { log: 'sc-log' } })
    config.selenium_connect.should eq({ log: 'sc-log' })
  end

  it 'should allow pass through of sauce options' do
    config =  ChemistryKit::Configuration.new selenium_connect: { log: 'sc-log', sauce_opts: { job_name: 'test' } }
    config.selenium_connect.should eq log: 'sc-log', sauce_opts: { job_name: 'test' }
  end
end
