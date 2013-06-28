[![Gem Version](https://badge.fury.io/rb/chemistrykit.png)](http://badge.fury.io/rb/chemistrykit)
[![Code Climate](https://codeclimate.com/github/arrgyle/chemistrykit.png)](https://codeclimate.com/github/arrgyle/chemistrykit)

Master branch: [![Build Status](https://travis-ci.org/arrgyle/chemistrykit.png?branch=master)](https://travis-ci.org/jrobertfox/chef-broiler-platter)

Develop branch: [![Build Status](https://travis-ci.org/arrgyle/chemistrykit.png?branch=develop)](https://travis-ci.org/jrobertfox/chef-broiler-platter)

ChemistryKit
============================================================

### A simple and opinionated web testing framework for Selenium WebDriver

This framework was designed to help you get started with Selenium WebDriver quickly, to grow as needed, and to avoid common pitfalls by following convention over configuration.

ChemistryKit's inspiration comes from the Saunter Selenium framework which is available in Python and PHP. You can find more about it [here](http://element34.ca/products/saunter).

## Getting Started

    $ gem install chemistrykit
    $ ckit new framework_name

This will create a new folder with the name you provide and it will contain all of the bits you'll need to get started.

    $ cd framework_name
    $ ckit generate beaker beaker_name

This will generate a beaker file (a.k.a. test script) with the name you provide (e.g. hello_world). Add your Selenium actions and assertions to it.

    $ ckit brew

This will run ckit and execute your beakers. By default it will run the tests locally by default. But you can change where the tests run and all other relevant bits in \_config.yaml. You can find out more about this [here](https://github.com/arrgyle/chemistrykit/wiki/Configs).


## Contributing
This project conforms to the [neverstopbuilding/craftsmanship](https://github.com/neverstopbuilding/craftsmanship) guidelines. Please see them for details on:
- Branching theory
- Documentation expectations
- Release process

###It's simple

1. Create a feature branch from develop: `git checkout -b feature/myfeature develop` or `git flow feature start myfeature`
2. Do something awesome.
3. Submit a pull request.

All issues and questions related to this project should be logged using the [github issues](https://github.com/arrgyle/chemistrykit/issues) feature.

### Install Dependencies

    bundle install

### Run rake task to test code

    rake build

### Run the local version of the executable:

    ckit

##Releaseing
The release process is rather automated, just use one rake task with the new version number:

    rake release_start['2.1.0']

And another to finish the release:

    rake release_finish['A helpful tag message that will be included in the gemspec.']

This handles updating the change log, committing, and tagging the release.
