Feature: ckit new

  Run `ckit new <project_name>` to generate a new ChemistryKit project.

  Background:
    When I run `ckit new booker`
    Then there should be a parent directory named booker
    And a directory named "beakers"
    And a directory named "formulas"
    And a directory named "evidence"
    And a file named ".rspec"
    And a directory named "_config"
    And a file named ".rspec"
    And a file named "_config/chemistrykit.yaml"
    And a file named "_config/requires.rb"
    And a file named "_config/saucelabs.yaml.example"

  Scenario: ckit new <booker>
    Then I should see a directory structure with:
    \```
    \ ├── booker
    \ │   ├── _config
    \ │   │   ├── chemistrykit.yaml
    \ │   │   ├── requires.rb
    \ │   │   └── saucelabs.yaml.example
    \ │   ├── beakers
    \ │   ├── evidence
    \ │   └── formulas
    \```

  Scenario: ckit new should update config with project name
    Then a file named "chemistrykit.yaml" should contain:
      """yaml
      ---
      chemistrykit: {
        project: Booker,
        capture_output: false,
        run_locally: true
      }
      """
