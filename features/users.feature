Feature: Users

  Scenario: I am logged in and I click logged out
    Given I log into the subdomain "test" and have created a server
    Given I am on the dashboard
    When I follow "Logout"
    Then I should see "You need to sign in or sign up before continuing."

  Scenario: I want to change my password
    Given I log into the subdomain "test" and have created a server
    Given I am on the dashboard
    When I follow "Change Password"
    When I fill in the following:
      | u_current_password | test123 |
      | u_password         | temp123 |
      | u_repeat_password  | temp123 |
    When I press "Update Password"
    Then I should see "You need to sign in or sign up before continuing."
    When I fill in the following:
      | user_email    | josh@bluescripts.net |
      | user_password | temp123              |
    And I press "Sign in"
    Then I should see "Signed in successfully."

  Scenario: I want to change my password, but left new password blank
    Given I log into the subdomain "test" and have created a server
    Given I am on the dashboard
    When I follow "Change Password"
    When I fill in the following:
      | u_current_password | test123 |
      | u_password         |         |
      | u_repeat_password  |         |
    When I press "Update Password"
    Then I should see "Password can't be blank"

  Scenario: I want to change my password, but forgot my current password
    Given I log into the subdomain "test" and have created a server
    Given I am on the dashboard
    When I follow "Change Password"
    When I fill in the following:
      | u_current_password | teasdasd |
      | u_password         |         |
      | u_repeat_password  |         |
    When I press "Update Password"
    Then I should see "Your old password is incorrect."



