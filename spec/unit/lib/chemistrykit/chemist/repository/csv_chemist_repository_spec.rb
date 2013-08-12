# Encoding: utf-8

require 'spec_helper'
require 'chemistrykit/chemist/repository/csv_chemist_repository'

describe ChemistryKit::Chemist::Repository::CsvChemistRepository do

  VALID_CHEMIST_CSV = 'chemists.csv'
  VALID_DEFAULT_CSV = 'default_chemists.csv'
  BAD_CHEMIST_CSV = 'bad_chemists.csv'
  KEYLESS_CHEMIST_CSV = 'keyless_chemists.csv'
  INVALID_CHEMIST_CSV = 'file_does_not_exist.csv'
  VALID_USER_TYPE = 'admin'
  VALID_USER_KEY = 'admin1'
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

  it 'should load a random by type identifier' do
    chemist = @repo.load_first_chemist_of_type VALID_USER_TYPE
    chemist.type.should eq VALID_USER_TYPE
  end

  it 'should load a random by specific key' do
    chemist = @repo.load_chemist_by_key VALID_USER_KEY
    chemist.key.should eq VALID_USER_KEY
  end

  it 'should load a random chemist by type' do
    chemist = @repo.load_random_chemist_of_type 'random'
    (chemist.key == 'ran1' || chemist.key == 'ran2').should be_true
  end

  it 'should set all the parameters defined in the csv file' do
    chemist = @repo.load_first_chemist_of_type VALID_USER_TYPE
    chemist.name.should eq 'Mr. Admin'
    chemist.email.should eq 'admin@email.com'
    chemist.password.should eq 'abc123$'
  end

  it 'should rais and error if the chemist is not found' do
    expect do
      @repo.load_first_chemist_of_type INVALID_USER_TYPE
    end.to raise_error ArgumentError, 'Chemist for type "no_type" not found!'
  end

  it 'should raise and error if there is no type heading in the csv file' do
    csv_file = File.join(Dir.pwd, 'spec', 'support', BAD_CHEMIST_CSV)
    expect do
      ChemistryKit::Chemist::Repository::CsvChemistRepository.new(csv_file)
    end.to raise_error ArgumentError, 'You must define a type field!'
  end

  it 'should raise and error if there is no key heading in the csv file' do
    csv_file = File.join(Dir.pwd, 'spec', 'support', KEYLESS_CHEMIST_CSV)
    expect do
      ChemistryKit::Chemist::Repository::CsvChemistRepository.new(csv_file)
    end.to raise_error ArgumentError, 'You must define a key field!'
  end

  it 'can search more than one csv file' do
    files = []
    files.push File.join(Dir.pwd, 'spec', 'support', VALID_CHEMIST_CSV)
    files.push File.join(Dir.pwd, 'spec', 'support', 'other_chemists.csv')
    repo = ChemistryKit::Chemist::Repository::CsvChemistRepository.new(files)

    chemist = repo.load_first_chemist_of_type 'cowboy'
    chemist.passion.should eq 'Wrasslin'

    chemist = repo.load_first_chemist_of_type 'normal'
    chemist.email.should eq 'normal@email.com'
  end

  it 'should replace the {{UUID}} token with a uuid on runtime if found in a parameter' do
    chemist = @repo.load_chemist_by_key 'uuid_chemist'
    # the {{UUID}} token was placed in the email parameter
    expect(chemist.email).to match(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/)
  end

  it 'should not raise any error if there were no modifications to the default chemists file' do
    csv_file = File.join(Dir.pwd, 'spec', 'support', VALID_DEFAULT_CSV)
    repo = ChemistryKit::Chemist::Repository::CsvChemistRepository.new(csv_file)
    repo.should be_an_instance_of ChemistryKit::Chemist::Repository::CsvChemistRepository
  end

  it 'should always return the same instance of any chemist' do
    chemist1 = @repo.load_chemist_by_key VALID_USER_KEY
    chemist2 = @repo.load_chemist_by_key VALID_USER_KEY
    expect(chemist2).to be(chemist1)
  end

  it 'should always return the same instance of any chemist by first type' do
    chemist1 = @repo.load_first_chemist_of_type VALID_USER_TYPE
    chemist2 = @repo.load_first_chemist_of_type VALID_USER_TYPE
    expect(chemist2).to be(chemist1)
  end

end
