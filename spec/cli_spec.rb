require 'chemistrykit'

describe 'Chemistry Kit' do
  let(:ckit) { ChemistryKit::CLI::CKitCLI.start }

  context "exit codes" do
    it "fail" do
      puts ckit.class
    end
  end
end
