require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'features/support/vcr_cassettes'
  c.hook_into :webmock
end

When /^I execute `([^`]*)`$/ do |cmd|
  VCR.use_cassette('brew') do
    run_simple(unescape(cmd), false)
#    response = Net::HTTP.get_response(URI('http://www.google.com/'))
  end
end

Then /^I should see a project with the following structure:$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^"(.*?)" is set as the project name$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end
