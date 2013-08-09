# Encoding: utf-8

require 'spec_helper'
require 'chemistrykit/chemist'

describe ChemistryKit::Chemist do

  VALID_KEY = 'specific_admin'
  VALID_TYPE = 'admin'
  VALID_VALUE = 'my value'

  before(:each) do
    @chemist = ChemistryKit::Chemist.new(VALID_KEY, VALID_TYPE)
  end

  it 'must have at least a key and type' do
    @chemist.key.should eq VALID_KEY
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

  it 'should not be able to override the key variable' do
    @chemist.key = 'other'
    @chemist.key.should eq VALID_KEY
    @chemist.data.include?(:key).should be_false
  end

  it 'should be able to be populated with a hash of arbitrary data' do
    dataset = { name: 'cool dude', email: 'fun@gmail.com', password: 'Oa8w*#)asd' }
    @chemist.data = dataset
    @chemist.name.should eq 'cool dude'
    @chemist.email.should eq 'fun@gmail.com'
  end
end
