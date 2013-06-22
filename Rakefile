require "bundler/gem_tasks"
require "cucumber"
require "cucumber/rake/task"
require 'rspec/core/rake_task'

task :default => [:build]

desc 'Runs standard build activities.'
task :build => [:clean, :prepare, :spec, :cucumber]

desc 'Removes the build directory.'
task :clean do
  FileUtils.rm_rf('build')
end

task :prepare do
  FileUtils.mkdir_p('build/tmp')
end

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:cucumber)
