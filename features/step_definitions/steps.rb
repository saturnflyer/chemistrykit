# Encoding: utf-8

When /^I overwrite ([^"]*) with:$/ do | file_name, file_content |
  # Modified from https://github.com/cucumber/aruba/blob/master/lib/aruba/cucumber.rb
  require 'erb'
  data = ERB.new(file_content)
  overwrite_file(file_name, data.result)
end

Then(/^the exit code should be (\d+)$/) do |exit_status|
  @last_exit_status.should == exit_status.to_i
end

Then(/^there should be "(.*?)" unique results files in the "(.*?)" directory$/) do |number_files, logs_path|
  files = Dir.glob(File.join(current_dir, logs_path, '*.xml'))
  count = 0
  files.each do |file|
    count += 1 if file =~ /parallel_part_\w{8}-(\w{4}-){3}\w{12}\.xml/
  end
  count.should == number_files.to_i
end
