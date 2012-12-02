Feature: Manageing users

  Scenario: Setting a second user to have permissions when there are no groups
    Given I log into the subdomain "test" and have created a server
    And there has been another user created
    Given I am on the dashboard
    When I follow "Users"
    When I click on the last user's manage link
    Then I should see "You must create a group before you can set a users permissions."
