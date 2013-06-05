require 'aruba/cucumber'

Before do
  @aruba_timeout_seconds = 90
  @dirs = ["tmp"]
end
