Feature: ckit new

  Run "ckit new <project_name>" to generate a new ChemistryKit project.

  Background: Running ckit new
    When I run `ckit new booker`
    And I cd to "booker"

  @announce
  Scenario: Project directory is created
    Then I should see a project with the following structure:
    # └── booker
    # ├── _config
    # │   ├── chemistrykit.yaml
    # │   ├── requires.rb
    # │   └── saucelabs.yaml.example
    # ├── beakers
    # ├── evidence
    # └── formulas

  Scenario: Project name is inserted in configs
    Then the file "_config/chemistrykit.yaml" should contain:
    """
    project: Booker
    """
