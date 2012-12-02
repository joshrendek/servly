Feature: Management apis
  
  Scenario: API Check
    Given I am on the api page
    Then I should see "Index"
    
  Scenario: I created a domain
    Given I add a user with subdomain "test", email "josh@bluescripts.net", password "test123", serverlimit "10", alert_limit "5", url_monitor_limit "3", and user_limit "2"
    Then I should see "User account created."
  
  Scenario: Changing a user password
    Given I have created a subdomain
    Given I change the password for "josh@bluescripts.net" to "temp123456"
    Then I should see "Success: changed user password"

  Scenario: Suspend Domain
    Given I have created a subdomain
    When I suspend subdomain "test"
    Then I should see "Domain suspended test"

  Scenario: After adding a user, API key is auto generated
    Given I have created a subdomain
    Then it should have an API key

