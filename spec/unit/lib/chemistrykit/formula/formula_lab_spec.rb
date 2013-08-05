# Encoding: utf-8

require 'spec_helper'
require 'chemistrykit/formula/formula_lab'

describe ChemistryKit::Formula::FormulaLab do

  VALID_FORMULA_KEY = 'my_formula'
  VALID_CHEMIST_KEY = 'admin1'
  VALID_CHEMIST_TYPE = 'admin'

  before(:each) do
    @stub_driver = double 'Selenium::WebDriver::Driver'
    @stub_repo = double 'ChemistryKit::Chemist::Repository::CsvChemistRepository', load_chemist_by_key: true, load_random_chemist_of_type: true, load_first_chemist_of_type: true
    formula_path = File.join(Dir.pwd, 'spec', 'support', 'formulas')
    @lab = ChemistryKit::Formula::FormulaLab.new @stub_driver, @stub_repo, formula_path
  end

  it 'should be initialized with a valid driver, chemist repo, and formula location' do
    @lab.should be_an_instance_of ChemistryKit::Formula::FormulaLab
  end

  it 'should raise an error if the formula folder is not found' do
    expect do
      ChemistryKit::Formula::FormulaLab.new @stub_driver, @stub_repo, '/not/here'
    end.to raise_error ArgumentError, 'Formula directory "/not/here" does not exist!'
  end

  it 'should respond to its api methods' do
    @lab.should respond_to :mix
    @lab.should respond_to :using
    @lab.should respond_to :with
    @lab.should respond_to :with_random
    @lab.should respond_to :with_first
  end

  it 'should let the formula key be set' do
    @lab.using(VALID_FORMULA_KEY)
    @lab.formula.should eq VALID_FORMULA_KEY
  end

  it 'should set the required chemist using with' do
    @lab.with(VALID_CHEMIST_KEY).should be @lab
    expect(@stub_repo).to have_received(:load_chemist_by_key).with(VALID_CHEMIST_KEY)
  end

  it 'should set the required chemist using with_random' do
    @lab.with_random(VALID_CHEMIST_TYPE).should be @lab
    expect(@stub_repo).to have_received(:load_random_chemist_of_type).with(VALID_CHEMIST_TYPE)
  end

  it 'should set the require chemist using with_first' do
    @lab.with_first(VALID_CHEMIST_TYPE).should be @lab
    expect(@stub_repo).to have_received(:load_first_chemist_of_type).with(VALID_CHEMIST_TYPE)
  end

  it 'should raise an error if mix is called and the formula is nil' do
    expect do
      @lab.mix
    end.to raise_error ArgumentError, 'A formula key must be defined!'
  end

end
