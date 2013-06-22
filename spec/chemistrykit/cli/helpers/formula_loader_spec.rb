require 'spec_helper'
#might be able to use something like this: https://github.com/alexeypetrushin/class_loader

describe ChemistryKit::CLI::Helpers::FormulaLoader do

  before(:each) do
    @loader = ChemistryKit::CLI::Helpers::FormulaLoader.new
    Dir.mkdir(File.join(TEST_TMP_PATH, 'formula'))
  end

  it 'should return a new instance of the loader' do
    @loader.should be_an_instance_of ChemistryKit::CLI::Helpers::FormulaLoader
  end

  it 'should return ruby files in alphabetical order' do
    #create some test files
    d = File.join(TEST_TMP_PATH, 'formula', 'd.rb')
    a = File.join(TEST_TMP_PATH, 'formula', 'a.rb')
    b = File.join(TEST_TMP_PATH, 'formula', 'b.rb')
    FileUtils.touch(d)
    FileUtils.touch(a)
    FileUtils.touch(b)

    #ensure the result
    @loader.get_formulas(File.join(TEST_TMP_PATH, 'formula')).should eq [a, b, d]

  end

  it 'should order files in child directories before parent directories' do
    Dir.mkdir(File.join(TEST_TMP_PATH, 'formula', 'child'))
    d = File.join(TEST_TMP_PATH, 'formula', 'child' ,'d.rb')
    b = File.join(TEST_TMP_PATH, 'formula', 'child' ,'b.rb')
    a = File.join(TEST_TMP_PATH, 'formula', 'a.rb')
    c = File.join(TEST_TMP_PATH, 'formula', 'c.rb')
    FileUtils.touch(d)
    FileUtils.touch(b)
    FileUtils.touch(a)
    FileUtils.touch(c)

    @loader.get_formulas(File.join(TEST_TMP_PATH, 'formula')).should eq [b, d, a, c]
  end

  it 'should load directories in alphabetical order' do
    Dir.mkdir(File.join(TEST_TMP_PATH, 'formula', 'abby'))
    Dir.mkdir(File.join(TEST_TMP_PATH, 'formula', 'road'))
    d = File.join(TEST_TMP_PATH, 'formula', 'abby' ,'d.rb')
    b = File.join(TEST_TMP_PATH, 'formula', 'road' ,'b.rb')
    FileUtils.touch(d)
    FileUtils.touch(b)
    @loader.get_formulas(File.join(TEST_TMP_PATH, 'formula')).should eq [d, b]
  end

  it 'should load any lib directory before any other' do
    Dir.mkdir(File.join(TEST_TMP_PATH, 'formula', 'lib'))
    Dir.mkdir(File.join(TEST_TMP_PATH, 'formula', 'abby'))
    d = File.join(TEST_TMP_PATH, 'formula', 'lib' ,'d.rb')
    b = File.join(TEST_TMP_PATH, 'formula', 'abby' ,'b.rb')
    FileUtils.touch(d)
    FileUtils.touch(b)
    @loader.get_formulas(File.join(TEST_TMP_PATH, 'formula')).should eq [d, b]
  end

  it 'should apply stack these rules deeply' do
    Dir.mkdir(File.join(TEST_TMP_PATH, 'formula', 'lib'))
    Dir.mkdir(File.join(TEST_TMP_PATH, 'formula', 'abby'))
    Dir.mkdir(File.join(TEST_TMP_PATH, 'formula', 'abby', 'lib'))
    Dir.mkdir(File.join(TEST_TMP_PATH, 'formula', 'abby', 'road'))

    a = File.join(TEST_TMP_PATH, 'formula', 'lib' ,'a.rb')
    c = File.join(TEST_TMP_PATH, 'formula', 'abby' ,'c.rb')
    b = File.join(TEST_TMP_PATH, 'formula', 'b.rb')
    d = File.join(TEST_TMP_PATH, 'formula', 'abby' , 'lib', 'd.rb')
    e = File.join(TEST_TMP_PATH, 'formula', 'abby' , 'road', 'e.rb')

    FileUtils.touch(a)
    FileUtils.touch(b)
    FileUtils.touch(c)
    FileUtils.touch(d)
    FileUtils.touch(e)

    @loader.get_formulas(File.join(TEST_TMP_PATH, 'formula')).should eq [a, d, e, c, b]
  end

  after(:each) do
    FileUtils.rm_rf(File.join(TEST_TMP_PATH, 'formula'))
  end
end
