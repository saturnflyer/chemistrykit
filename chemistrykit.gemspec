# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chemistrykit/version'

Gem::Specification.new do |s|
  s.name          = "chemistrykit"
  s.version       = ChemistryKit::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Dave Haeffner", "Jason Wieringa"]
  s.email         = ["dave@arrgyle.com", "jason@arrgyle.com"]
  s.homepage      = "https://github.com/arrgyle/chemistrykit"
  s.summary       = "Simple and opinionated web testing framework for Selenium that follows convention over configuration -- borrowed from Saunter, built in Ruby"
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.test_files    = s.files.grep(%r{^(scripts|spec|features)/})
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>=1.9'

  s.add_dependency "thor", "~> 0.17.0"
  s.add_dependency "rspec", "~> 2.12.0"
  s.add_dependency "selenium-webdriver", "~> 2.29.0"
  s.add_dependency "ci_reporter", "~> 1.8.3"
  s.add_dependency "rest-client", "~> 1.6.7"
  s.add_dependency "json"

  s.add_development_dependency "rspec", "~> 2.12.0"
  s.add_development_dependency "aruba", "~> 0.5.1"
  s.add_development_dependency "cucumber", "~> 1.2.1"
  s.add_development_dependency "rake", "~> 10.0.3"

  s.extensions = 'ext/mkrf_conf.rb'
end
