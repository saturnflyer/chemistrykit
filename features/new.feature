Feature: ckit new

  Run "ckit new <project_name>" to generate a new ChemistryKit project

  Background: Running ckit new
    When I run `bundle exec ckit new booker`
    And I cd to "booker"

  @announce
  Scenario: Test Harness is created
    Then the following directories should exist:
      | beakers  |
      | formulas |
      | evidence |
    And the following files should exist:
      | _config.yaml  |
      | .rspec        |
