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

  it 'should not be able to override the key, or with variable' do
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

  it 'should be able to change the chemist type' do
    @chemist.type = 'new_type'
    @chemist.type.should eq 'new_type'
  end

  it 'should be able to add another chemist as a data element' do
    sub_chemist = ChemistryKit::Chemist.new('sub_key', 'sub_type')
    other_sub = ChemistryKit::Chemist.new('other_key', 'other_type')
    @chemist.with(sub_chemist).with(other_sub)
    @chemist.sub_type.key.should eq 'sub_key'
    @chemist.sub_type.type.should eq 'sub_type'
    @chemist.other_type.key.should eq 'other_key'
    @chemist.other_type.type.should eq 'other_type'
  end

end
