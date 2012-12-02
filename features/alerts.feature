Feature: Alerts

  Scenario: I want to create an alert, but haven't created a group
    Given I log into the subdomain "test" and have created a server
    When I go to the alerts page
    Then I should see "You need to create a group first."

  Scenario: I want to create an alert, and have created a group
    Given I log into the subdomain "test" and have created a server
    Given I go to the new group page
    And I fill in the following:
      | group_name  | Test            |
      | group_notes | some test notes |
    And I press "Create Group"
    Then I should see "Group was successfully created."
    When I go to the alerts page
    Then I should see "New Alert"
    
    
  Scenario: I create an alert, what should I see
    Given I log into the subdomain "test" and have created a server
    Given I have created a group
    When I go to the new alert page
    Then I should see "New alert"
    Given I fill in the following:
         | alert_threshold_value | 100 |
    And I press "Create Alert"
    Then I should see "Alerts"
    And I should see "Alerting"
    And I should see "Destroy"
    And I should see "Alert was successfully created."
