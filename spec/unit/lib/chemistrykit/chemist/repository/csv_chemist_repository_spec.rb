# Encoding: utf-8

require 'spec_helper'
require 'chemistrykit/chemist/repository/csv_chemist_repository'

describe ChemistryKit::Chemist::Repository::CsvChemistRepository do

  VALID_CHEMIST_CSV = 'chemists.csv'
  BAD_CHEMIST_CSV = 'bad_chemists.csv'
  INVALID_CHEMIST_CSV = 'file_does_not_exist.csv'
  VALID_USER_TYPE = 'admin'
  INVALID_USER_TYPE = 'no_type'

  before(:each) do
    csv_file = File.join(Dir.pwd, 'spec', 'support', VALID_CHEMIST_CSV)
    @repo = ChemistryKit::Chemist::Repository::CsvChemistRepository.new(csv_file)
  end

  it 'should be instantiated with a csv file path' do
    @repo.should be_an_instance_of ChemistryKit::Chemist::Repository::CsvChemistRepository
  end

  it 'should raise and error if the file does not exist' do
    expect do
      csv_file = File.join(Dir.pwd, 'spec', 'support', INVALID_CHEMIST_CSV)
      ChemistryKit::Chemist::Repository::CsvChemistRepository.new(csv_file)
    end.to raise_error ArgumentError, 'Supplied file does not exist!'
  end

  it 'should load a user by type identifier' do
    chemist = @repo.load_chemist VALID_USER_TYPE
    chemist.type.should eq VALID_USER_TYPE
  end

  it 'should set all the parameters defined in the csv file' do
    chemist = @repo.load_chemist VALID_USER_TYPE
    chemist.name.should eq 'Mr. Admin'
    chemist.email.should eq 'admin@email.com'
    chemist.password.should eq 'abc123$'
  end

  it 'should rais and error if the chemist is not found' do
    expect do
      @repo.load_chemist INVALID_USER_TYPE
    end.to raise_error ArgumentError, 'Chemist for type "no_type" not found!'
  end

  it 'should raise and error if there is no type heading in the csv file' do
    csv_file = File.join(Dir.pwd, 'spec', 'support', BAD_CHEMIST_CSV)
    expect do
      ChemistryKit::Chemist::Repository::CsvChemistRepository.new(csv_file)
    end.to raise_error ArgumentError, 'You must define a type field!'
  end

end
