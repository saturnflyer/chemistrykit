[![Gem Version](https://badge.fury.io/rb/chemistrykit.png)](http://badge.fury.io/rb/chemistrykit)
[![Dependency Status](https://gemnasium.com/arrgyle/chemistrykit.png)](https://gemnasium.com/arrgyle/chemistrykit)
[![Code Climate](https://codeclimate.com/github/arrgyle/chemistrykit.png)](https://codeclimate.com/github/arrgyle/chemistrykit)

ChemistryKit
============================================================

### A simple and opinionated web testing framework for Selenium WebDriver

This framework was designed to help you get started with Selenium quickly, to grow as needed, and to avoid common pitfalls by following convention over configuration.  

ChemistryKit's inspiration comes from the Saunter Selenium framework, which is available in Python and PHP. You can find more about it [here](http://element34.ca/products/saunter).  

## Getting Started

    $ gem install chemistrykit
    $ ckit new framework_name

This will create a new folder based on the name you provide. It contains all of the bits you'll need to get started.

    $ cd framework_name
    $ ckit generate beaker beaker_name

This will generate a beaker file (a.k.a. test script). Add your Selenium actions to it, save it, and run ckit.

    $ ckit brew

This will run your beaker locally by default. You can change where the tests run and all other relevant bits in [\_config.yaml](https://github.com/arrgyle/chemistrykit/wiki/Configs).


## Contributing

This project conforms to the [neverstopbuilding/craftsmanship](https://github.com/neverstopbuilding/craftsmanship) guidelines. Please see them for details.
