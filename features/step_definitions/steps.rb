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
    count += 1 if file =~ /junit_\d+\.xml/
  end
  count.should == number_files.to_i
end

Then(/^there should be "(.*?)" "(.*?)" log files in "(.*?)"$/) do |number, type, logs_path|
  files = Dir.glob(File.join(current_dir, logs_path, '*.*'))
  count = 0
  files.each do |file|
    case type
    when 'failed image'
      count += 1 if file =~ /failshot\.png/
    when 'report'
      count += 1 if file =~ /sauce_job\.log/
    when 'sauce log'
      count += 1 if file =~ /server\.log/
    end
  end
  count.should == number.to_i
end
