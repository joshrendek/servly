Feature: Dashboard 

  Scenario: I'm a brand new user, what do I see?
    # fix collective stat errors
    # check redirects
    Given I have created a subdomain
    Given I visit subdomain "test"
    Given I am an authenticated user
    Then I should see "You must add a server"

  Scenario: I've added a server, but collective stats hasnt run
    Given I have created a subdomain
    And I visit subdomain "test"
    And I have added a server
    When I am an authenticated user
    Then I should see "foobar"

  
