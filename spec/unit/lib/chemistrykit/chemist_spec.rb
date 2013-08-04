# Encoding: utf-8

require 'spec_helper'
require 'chemistrykit/chemist'

describe ChemistryKit::Chemist do

  VALID_TYPE = 'admin'
  VALID_VALUE = 'my value'

  before(:each) do
    @chemist = ChemistryKit::Chemist.new(VALID_TYPE)
  end

  it 'must have at least a type' do
    @chemist.type.should eq VALID_TYPE
  end

  it 'should be able to set and get arbitrary data' do
    @chemist.my_key = VALID_VALUE
    @chemist.my_key.should eq VALID_VALUE
  end

  it 'should be able to get a hash of its data' do
    @chemist.my_key = VALID_VALUE
    @chemist.data.should eq my_key: VALID_VALUE
  end

  it 'should not be able to override the other instance variables' do
    @chemist.type = 'other'
    @chemist.type.should eq VALID_TYPE
    @chemist.data.include?(:type).should be_false
  end

  it 'should be able to be populated with a hash of arbitrary data' do
    dataset = { name: 'cool dude', email: 'fun@gmail.com', password: 'Oa8w*#)asd' }
    @chemist.data = dataset
    @chemist.name.should eq 'cool dude'
    @chemist.email.should eq 'fun@gmail.com'
  end
end
