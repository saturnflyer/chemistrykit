# Encoding: utf-8

require 'aruba/cucumber'

Before do
  FileUtils.rm_rf('build/tmp')
  @aruba_timeout_seconds = 400
  @dirs = ['build/tmp']
end
