Feature: User has a single profile
  For some reason
  As a user
  I want to be able to choose among different profiles
  
  Scenario: User has one profile
    Given A User "Fred"
    And a Profile "R" with color "Red"
    When he assigns Profile "R"
    Then he should have a Profile "R"
  
  
  

  
