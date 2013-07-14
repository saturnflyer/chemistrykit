# Encoding: utf-8

require 'bundler/gem_tasks'
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

task default: :build

desc 'Runs standard build activities.'
task build: [:clean, :prepare, :rubocop, :unit, :integration]

desc 'Runs standard build activities for ci server.'
task build_full: [:clean, :prepare, :rubocop, :unit, :integration, :system]

desc 'Removes the build directory.'
task :clean do
  FileUtils.rm_rf('build')
end

desc 'Adds the build tmp directory for test kit creation.'
task :prepare do
  FileUtils.mkdir_p('build/tmp')
  FileUtils.mkdir_p('build/spec')
end

def get_rspec_flags(log_name, others = nil)
  "--format documentation --out build/spec/#{log_name}.log --format html --out build/spec/#{log_name}.html --format progress #{others}"
end

RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = FileList['spec/unit/**/*_spec.rb']
  t.rspec_opts = get_rspec_flags('unit')
end

RSpec::Core::RakeTask.new(:integration) do |t|
  t.pattern = FileList['spec/integration/**/*_spec.rb']
  t.rspec_opts = get_rspec_flags('integration')
end

Cucumber::Rake::Task.new(:system)

desc 'Runs code quality check'
task :rubocop do
  sh 'rubocop'
end

# TODO This could probably be more cleanly automated
desc 'Start a release (Requires Git Flow)'
task :release_start, :version do |t, args|
  version = args['version']

  # make sure we have the latest stuff
  system 'git fetch --all'

  # first make sure master is checked out and up to date
  system 'git checkout master'
  system 'git pull --no-edit origin master'

  # then make sure develop is up to date
  system 'git checkout develop'
  system 'git pull --no-edit origin develop'

  # next assure all the tests run
  task(:build_full).invoke

  # start the release process
  system "git flow release start #{version}"

  # update the version number in the .gemspec file
  gemspec = File.join(Dir.getwd, 'chemistrykit.gemspec')
  updated = File.read(gemspec).gsub(
    /s.version(\s+)=(\s?["|']).+(["|'])/,
    "s.version\\1=\\2#{version}\\3"
  )
  File.open(gemspec, 'w') { |f| f.write(updated) }

  # commit the version bump
  system 'git add chemistrykit.gemspec'
  system "git commit -m 'Bumped version to #{version} to prepare for release.'"

  puts "You've started release #{version}, make any last minute updates now.\n"
end

# TODO This could probablly be more cleanly automated
desc 'Finish a release (Requires Git Flow and Gem Deploy Permissions'
task :release_finish, :update_message do |t, args|
  message   = args['update_message']
  gemspec   = File.join(Dir.getwd, 'chemistrykit.gemspec')
  changelog = File.join(Dir.getwd, 'CHANGELOG.md')
  version   = File.read(gemspec).match(/s.version\s+=\s?["|'](.+)["|']/)[1]

  ### Changelog
  # get the latest tag
  system 'git checkout master'
  last_tag = `git describe --abbrev=0`
  system "git checkout release/#{version}"

  # get the commit hash since the last that version was merged to develop
  hash = `git log --grep="Merge branch 'release/#{last_tag.chomp}' into develop" --format="%H"`
  # get all the commits since them less merges
  log = `git log --format="- %s" --no-merges #{hash.chomp}..HEAD`

  changelog_contents = File.read(changelog)
  date = Time.new.strftime('%Y-%m-%d')
  # create the new heading
  updated_changelog = "##{version} (#{date})\n" + message + "\n\n" + log + "\n" + changelog_contents
  # update the contents
  File.open(changelog, 'w') { |f| f.write(updated_changelog) }
  puts "Updated change log for version #{version}\n"

  ### Update the gemspec with the message
  updated_gemspec = File.read(gemspec).gsub(
    /s.description(\s+)=(\s?["|']).+(["|'])/,
    "s.description\\1=\\2#{message}\\3"
  )
  File.open(gemspec, 'w') { |f| f.write(updated_gemspec) }

  ### Update the readme heading
  updated = File.read(readme).gsub(
    /^#selenium-connect \d+\.\d+.\d+ \(.+\)/,
    "#selenium-connect #{version} (#{date})"
  )
  File.open(readme, 'w') { |f| f.write(updated) }

  # Commit the updated change log and gemspec and readme
  system "git commit -am 'Updated CHANGELOG.md gemspec and readme heading for #{version} release.'"

  # build the gem
  system 'gem build chemistrykit.gemspec'

  # push the gem
  system "gem push chemistrykit-#{version}.gem"

  # remove the gem file
  system "rm chemistrykit-#{version}.gem"

  # finish the release
  # TODO there is a bug with git flow, and you still need to deal with merge
  # messages, might just do this with git directly
  system "git flow release finish -m'#{version}' #{version}"

  # push develop
  system 'git push origin develop'

  # push master
  system 'git push origin master'

  # push tags
  system 'git push --tags'

  puts "Rock and roll, you just released ChemistryKit #{version}!\n"
end
