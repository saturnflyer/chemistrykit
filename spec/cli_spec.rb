describe 'Chemistry Kit' do
  let(:brew) { ChemistryKit::CLI::CKitCLI.start }

  context "exit codes" do
    it "pass"

    it "fail" do
      brew
    end

  end
end
