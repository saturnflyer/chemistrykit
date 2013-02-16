require 'erb'

#Modified from https://github.com/cucumber/aruba/blob/master/lib/aruba/cucumber.rb

When /^I overwrite ([^"]*) with:$/ do |file_name, file_content|
  data = ERB.new(file_content) 
  overwrite_file(file_name, data.result)
end

## up and coming
#require 'webmock'
#require 'VCR'
#
#VCR.configure do |c|
#  c.cassette_library_dir = 'support/vcr_cassettes'
#  c.hook_into :webmock 
#end
#
#When /^I execute `([^`]*)`$/ do |cmd|
#  run_simple(unescape(cmd), false)
#end
