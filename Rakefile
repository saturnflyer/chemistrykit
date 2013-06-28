require "bundler/gem_tasks"
require "cucumber"
require "cucumber/rake/task"
require 'rspec/core/rake_task'

task :default => [:build_ci]

desc 'Runs standard build activities.'
task :build => [:clean, :prepare, :spec, :cucumber]

desc 'Runs standard build activities for ci server.'
task :build_ci => [:clean, :prepare, :spec]

desc 'Removes the build directory.'
task :clean do
  FileUtils.rm_rf('build')
end
desc 'Adds the build tmp directory for test kit creation.'
task :prepare do
  FileUtils.mkdir_p('build/tmp')
end

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:cucumber)


#TODO This could probablly be more cleanly automated
desc 'Start a release (Requires Git Flow)'
task :release_start, :version do |t, args|
  version = args['version']

  #make sure we have the latest stuff
  system "git fetch --all"

  #first make sure master is checked out and up to date
  system "git checkout master"
  system "git pull --no-edit origin master"

  #then make sure develop is up to date
  system "git checkout develop"
  system "git pull --no-edit origin develop"

  #next assure all the tests run
  task(:build).invoke

  #start the release process
  system "git flow release start #{version}"

  #update the version number in the .gemspec file
  gemspec = File.join(Dir.getwd, 'chemistrykit.gemspec')
  updated = File.read(gemspec).gsub(/s.version(\s+)=(\s?["|']).+(["|'])/){
    "s.version#{$1}=#{$2}#{version}#{$3}"
  }
  File.open(gemspec, 'w'){ |f| f.write(updated) }

  #commit the version bump
  system "git add chemistrykit.gemspec"
  system "git commit -m 'Bumped version to #{version} to prepare for release.'"

  puts "You've started release #{version}, make any last minute updates now.\n"
end

#TODO This could probablly be more cleanly automated
desc 'Finish a release (Requires Git Flow and Gem Deploy Permissions'
task :release_finish, :update_message do |t, args|
  message   = args['update_message']
  gemspec   = File.join(Dir.getwd, 'chemistrykit.gemspec')
  changelog = File.join(Dir.getwd, 'CHANGELOG.md')
  version   = File.read(gemspec).match(/s.version\s+=\s?["|'](.+)["|']/)[1]

  ###Changelog
  #get the latest tag
  last_tag = `git describe --abbrev=0`
  #get the commit hash since the last that version was merged to develop
  hash = `git log --grep="Merge branch 'release/#{last_tag.chomp}' into develop" --format="%H"`
  #get all the commits since them less merges
  log = `git log --format="- %s" --no-merges #{hash.chomp}..HEAD`

  changelog_contents = File.read(changelog)
  date = Time.new.strftime("%Y-%m-%d")
  #create the new heading
  updated_changelog = "##{version} (#{date})\n" + log + "\n" + changelog_contents
  #update the contents
  File.open(changelog, 'w'){ |f| f.write(updated_changelog) }
  puts "Updated change log for version #{version}\n"

  ###Update the gemspec with the message
  updated_gemspec = File.read(gemspec).gsub(/s.description(\s+)=(\s?["|']).+(["|'])/){
    "s.description#{$1}=#{$2}#{message}#{$3}"
  }
  File.open(gemspec, 'w'){ |f| f.write(updated_gemspec) }

  #Commit the updated change log and gemspec
  system "git commit -am 'Updated CHANGELOG.md and gemspec for #{version} release.'"

  #build the gem
  system "gem build chemistrykit.gemspec"

  #push the gem
  system "gem push chemistrykit-#{version}.gem"

  #remove the gem file
  system "rm chemistrykit-#{version}.gem"

  #finish the release
  system "git flow release finish -m '#{message}' #{version}"

  #push develop
  system "git push origin develop"

  #push master
  system "git push origin master"

  #push tags
  system "git push --tags"

  puts "Rock and roll, you just released ChemistryKit #{version}!\n"
end
