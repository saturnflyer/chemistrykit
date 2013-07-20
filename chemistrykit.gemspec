# Encoding: utf-8

Gem::Specification.new do |s|
  s.name          = 'chemistrykit'
  s.version       = '3.6.0'
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Dave Haeffner', 'Jason Fox']
  s.email         = ['dave@arrgyle.com', 'jason@arrgyle.com']
  s.homepage      = 'https://github.com/arrgyle/chemistrykit'
  s.summary       = 'A simple and opinionated web testing framework for Selenium that follows convention over configuration.'
  s.description   = 'Added the ability for tests to be retried on failure. A single retry will be attempted by default and the output will be verbose.'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.files.reject! { |file| file.include? '.jar' }
  s.test_files    = s.files.grep(%r{^(scripts|spec|features)/})
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>=1.9'

  s.add_dependency 'thor', '~> 0.17.0'
  s.add_dependency 'rspec', '~> 2.14.1'
  s.add_dependency 'yarjuf', '~> 1.0.5'
  s.add_dependency 'selenium-webdriver', '~> 2.29.0'
  s.add_dependency 'rest-client', '~> 1.6.7'
  s.add_dependency 'selenium-connect', '~> 3.2.0'
  s.add_dependency 'parallel_tests', '~> 0.15.0'
  s.add_dependency 'parallel', '~> 0.7.0'
  s.add_dependency 'rspec-retry', '~> 0.2.1'

  s.add_development_dependency 'rspec', '~> 2.14.1'
  s.add_development_dependency 'aruba', '~> 0.5.1'
  s.add_development_dependency 'cucumber', '~> 1.2.1'
  s.add_development_dependency 'rake', '~> 10.0.3'
  s.add_development_dependency 'rubocop', '~> 0.9.0'
  s.add_development_dependency 'guard-rspec', '~> 3.0.2'
  s.add_development_dependency 'coveralls', '~> 0.6.7'
end
