Feature: ckit new

  Run "ckit new <project_name>" to generate a new ChemistryKit project.

  Scenario: Running ckit new
    When I run `ckit new booker`
    Then create a directory named "booker"
    And a directory named "beakers"
    And a directory named "formulas"
    And a directory named "evidence"
    And a file named ".rspec"
    And a directory named "_config"
    And a file named "_config/chemistrykit.yaml" with:
      """yaml
      ---
      chemistrykit: {
        project: Booker,
        capture_output: false,
        run_locally: true
      }
      """
    And a file named "_config/requires.rb"
    And a file named "_config/saucelabs.yaml.example"
