# Encoding: utf-8

require 'spec_helper'
require 'chemistrykit/reporting/html_report_assembler'

describe ChemistryKit::Reporting::HtmlReportAssembler do

  before(:each) do
    results_folder = File.join(Dir.pwd, 'spec', 'support', 'evidence')
    output_file = File.join(Dir.pwd, 'build', 'tmp', 'final_results.html')
    @assembler = ChemistryKit::Reporting::HtmlReportAssembler.new(results_folder, output_file)
  end

  it 'should be initialized with folder path and output path' do
    @assembler.should be_an_instance_of ChemistryKit::Reporting::HtmlReportAssembler
  end

  it 'should respond to assemble' do
    @assembler.should respond_to :assemble
  end

end
