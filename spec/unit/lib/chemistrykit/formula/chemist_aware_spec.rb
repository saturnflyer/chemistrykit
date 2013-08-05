# Encoding: utf-8

require 'spec_helper'
require 'chemistrykit/formula/chemist_aware'

describe ChemistryKit::Formula::ChemistAware do

  class StubFormula
    include ChemistryKit::Formula::ChemistAware
  end

  before(:each) do
    @stub_formula = StubFormula.new
    @stub_chemist = double 'ChemistryKit::Chemist'
  end

  it 'should have accessors for the chemist' do
    @stub_formula.chemist = @stub_chemist
    @stub_formula.chemist.should be @stub_chemist
  end

  it 'should define a way to check if the formula is user aware' do
    @stub_formula.singleton_class.include?(ChemistryKit::Formula::ChemistAware).should be_true
  end
end
