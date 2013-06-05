require 'erb'

#Modified from https://github.com/cucumber/aruba/blob/master/lib/aruba/cucumber.rb
When /^I overwrite ([^"]*) with:$/ do |file_name, file_content|
  data = ERB.new(file_content)
  overwrite_file(file_name, data.result)
end
