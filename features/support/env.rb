# Encoding: utf-8

require 'aruba/cucumber'

Before do
  FileUtils.rm_rf('build/tmp')
  @aruba_timeout_seconds = (3 * 60)
  @dirs = ['build/tmp']
end
