When /^I overwrite ([^"]*) with:$/ do |file_name, file_content|
  #Modified from https://github.com/cucumber/aruba/blob/master/lib/aruba/cucumber.rb
  require 'erb'
  data = ERB.new(file_content)
  overwrite_file(file_name, data.result)
end

Then(/^the exit code should be (\d+)$/) do |exit_status|
  $?.exitstatus.should == exit_status.to_i
end
