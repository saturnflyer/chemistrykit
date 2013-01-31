Feature: ckit new

  Run "ckit new <project_name>" to generate a new ChemistryKit project.

  Background: Running ckit new
    When I run `ckit new booker`

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
    Then a file named "_config/chemistrykit.yaml" has:
      """yaml
      ---
      chemistrykit: {
        project: Booker,
        capture_output: false,
        run_locally: true
      }
      """
