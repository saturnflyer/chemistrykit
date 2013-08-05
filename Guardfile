# Encoding: utf-8

guard :rspec do
  watch(%r{^spec/unit/.+_spec\.rb$})
  watch(%r{^spec/integration/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/unit/lib/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/integration/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

guard :rubocop, all_on_start: false do
  watch(%r{^spec/.+\.rb$})
  watch(%r{^lib/.+\.rb$})
end
