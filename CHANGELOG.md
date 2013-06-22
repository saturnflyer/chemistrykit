#1.3.0 (2013-06-22)
- Added explicit recursive file loading process for formulas
- Cleaned up documentation
- Updated tests
- Cleaned up logging

#1.2.1 (2013-06-21)
- Bumping version number and adding Jason Fox as an author
- Making it so symbol values as tags in beakers will default to true if no value is set to them
- Pulled out the log value setter from shared_context and rolled this up into selenium-connect instead. Bumped to new version of selenium-connect to get this functionality
- Reworked the status check and exit logic order and implemented it as a ternary (effectively regressing back to what was there way back when). A better band-aid fix for now.
- added small tweak to catch the {} returned by calling ckit, which was giving an hash to integer conversion error
- Bumped version and removed the un-used spec dir
- Fixes #59. Will need to revisit the approach since it is a workaround given difficulties in getting Thor's self.exit_on_failure?; true; end to work properly Re: https://github.com/erikhuda/thor/issues/244
- Added a test to capture the exit status issue
- Updated the spec and moved it up a dir
- removed symlinking of historical log files and cleaned up the logging system to output the junit xml and the server log to the evidence directory. Added a bit of test for that.
- updated git ignore for build directory and changed the new feature to a different name to prevent conflicts
- removed non running spec
- added a few rake tasks and switched to standard build directory
#1.1.1 (2013-06-09)
- Bumping selenium-connect version to account for sauce gem breaking changes

#1.1.0 (2013-06-09)
- Added the ability to pass in environment variables with ckit brew --params=THING1:value THING2:value

#1.0.0 (2013-06-05)
- Removed a hard-coded exit code checker from the ckit binary, also adjusted the requires in it to use the top level chemistrykit file in lib. Had to rework that file as well. Also updated the readme
- Looks like my previous commit didn't include the cleanup of old files. Here you go! Also, updated the readme slightly
- Wired up selenium-connect and gladly gutted a heap of code that it replaced. Also, updated the readme and updated the gemspec.
- Readded the new commmand since someone got a little code clippy. Wired up the assertion in the "new" test so it actually works. And made the tmp directory listing explicit.
- Adding tmp directory to gitignore
- Updating gitignore for rvmrc
- Added string interpolation for doc strings with erb and consolidated the brew feature into a single scenario outline with an examples table
- Simplified ckit generate with a proper subcommand
- Tested on local branch, tests passing. Removed puts.
- Add the requires back to the method, not happy about it, but necessary for now
- Didn't comment out all of one scenario: fixed
- Disabled sauce with chrome scenario, without a way to check sauce to see if chrome is being used, it's the same as sauce with firefox
- All four scenarios working. Sacuelabs credentials needed in order for tests to run.
- Wait only 15 seconds intead of 30 seconds
- Passing selenium-webdriver and local selenium server scenarios
- Disabled new.feature, updated brew.feature with 4 types of scenarios
- Removed usage title, it already has a good title
- Brew cmd not default, updated documentation to reflect change
- Removed a duplicate if statement, added a lot of puts to see what's happening
- Added before(:all) hook to fix #48, refactored more logic out of before(:each)
- Condensed to methods for driver into one
- Updated the generated beaker with a formula to use the let incantation.
- Required formula in generator
- changelog updated to v0.1.1
- Added rake back to the gemspec becuase we are using it
- remove more self's
- You don't need to reference self so much, it will figure it out
- You don't need to initialize instance methods unless you want to set their value
- Passing variables from module Sauce to Ckit in a safer way, fixed bug where executor was being called twice per test
- Extracted sauce actions into a module
- Refactored logic out of after:each into methods
- Case statement for symlinking, added notes about they whys
- seperated rspec configuration from tagging logic
- log_timestamp was being called twice and creating two different values - fixed
- Removal of if statement, using ln_sf forces the creation of a symlink if one already exists
- Refactored logic for brew command into protected methods
- Added code climate badge
- Corrected version #
- Adding a tag for testing the testing of aruba
- Added a passing brew commit command and modified support.rb to env.rb like the docs say
- More updates to make it less overhead
- Simplified the new cli feature file, I think I'm starting to get aruba
- Told git to ignore the files that aruba is creating and updated new feature
- Cucumber spec for ckit new command
- Removed rake because we're not using it, added aruba and cucumber because living docs for the Cli is cool
- Please load aruba when you run feature files

#0.1.1 (2013-02-02)

* `ckit new` generates a chemistrykit project
* Execute tests in SauceLabs Ondemand
* Selenium server test execution
* Local test execution via selenium-webdriver
* Minimum page object model
* Page and beaker generation via `ckit generate`
* Discovery via tags
* Random execution
* Customization via yaml files
* Integration hook for CI
* Works from 'gem install' on both windows and unix
* Wrapper around WebDriver
