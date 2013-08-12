# Encoding: utf-8

require 'spec_helper'
require 'chemistrykit/formula/formula_lab'
require 'chemistrykit/chemist/repository/csv_chemist_repository'

describe ChemistryKit::Formula::FormulaLab do

  VALID_CHEMIST_KEY = 'admin1'
  VALID_CHEMIST_TYPE = 'admin'

  VALID_BASIC_FORMULA_KEY = 'basic_formula'
  VALID_CHEMIST_FORMULA_KEY = 'chemist_formula'
  VALID_ALTERNATE_CHEMIST_FORMULA = 'alt_chemist_formula'

  before(:each) do
    @stub_driver = double 'Selenium::WebDriver::Driver'
    files = []
    files.push File.join(Dir.pwd, 'spec', 'support', 'chemists.csv')
    files.push File.join(Dir.pwd, 'spec', 'support', 'other_chemists.csv')
    @repo = ChemistryKit::Chemist::Repository::CsvChemistRepository.new files
    formulas_dir = File.join(Dir.pwd, 'spec', 'support', 'formulas')
    @lab = ChemistryKit::Formula::FormulaLab.new @stub_driver, @repo, formulas_dir
  end

  it 'should mix a formula without a chemist' do
    formula = @lab.mix(VALID_BASIC_FORMULA_KEY)
    formula.should be_an_instance_of Formulas::SubModule::BasicFormula
  end

  it 'should mix a formula with a chemist the standard way' do
    formula = @lab.using(VALID_CHEMIST_FORMULA_KEY).with(VALID_CHEMIST_KEY).mix
    formula.should be_an_instance_of Formulas::SubModule::ChemistFormula
    formula.chemist.key.should eq VALID_CHEMIST_KEY
  end

  it 'should raise an error if trying to mix a formula that requires a user, without setting one' do
    expect do
      @lab.using(VALID_CHEMIST_FORMULA_KEY).mix
    end.to raise_error RuntimeError, "Trying to mix a formula: \"#{VALID_CHEMIST_FORMULA_KEY}\" that requires a user, but no user set!"
  end

  it 'should mix a formula in the oposite way' do
    formula = @lab.with(VALID_CHEMIST_KEY).mix(VALID_CHEMIST_FORMULA_KEY)
    formula.should be_an_instance_of Formulas::SubModule::ChemistFormula
    formula.chemist.key.should eq VALID_CHEMIST_KEY
  end

  it 'should mix a formula with a typed chemist' do
    formula = @lab.with_first(VALID_CHEMIST_TYPE).mix(VALID_CHEMIST_FORMULA_KEY)
    formula.should be_an_instance_of Formulas::SubModule::ChemistFormula
    formula.chemist.key.should eq VALID_CHEMIST_KEY
  end

  it 'should mix a formula with a random chemist of a type' do
    formula = @lab.with_random('random').mix(VALID_CHEMIST_FORMULA_KEY)
    formula.should be_an_instance_of Formulas::SubModule::ChemistFormula
    key = formula.chemist.key
    (key == 'ran1' || key == 'ran2').should be_true
  end

  it 'should deliver formulas with the same instance of chemist if indicated' do
    formula1 = @lab.using(VALID_CHEMIST_FORMULA_KEY).with(VALID_CHEMIST_KEY).mix
    formula2 = @lab.using(VALID_ALTERNATE_CHEMIST_FORMULA).with(VALID_CHEMIST_KEY).mix

    expect(formula1.chemist).to be(formula2.chemist)
    formula2.change_chemist_type 'other'
    formula1.chemist.type.should eq 'other'

    formula1.chemist.type = 'new'
    formula2.chemist.type.should eq 'new'
  end

  it 'should get chemists from different files' do
    formula1 = @lab.using(VALID_CHEMIST_FORMULA_KEY).with_first('cowboy').mix
    formula1.chemist.passion.should eq 'Wrasslin'
    formula2 = @lab.using(VALID_ALTERNATE_CHEMIST_FORMULA).with_first('normal').mix
    formula2.chemist.email.should eq 'normal@email.com'
  end

end
