Feature: Sign In
  In order to get access to protected sections of the site
  As a user
  I want to be able to connect with this site using my existing existing identity

    Scenario: A brand new user connects to the site for the first time with a good email address
      Given I do not exist as a user
        And I am not logged in
      When I authenticate successfully with Facebook and Facebook returns a usable email address
      Then I should be signed in

    Scenario: A brand new user connects to the site for the first time with a a bad or missing email address
      Given I do not exist as a user
        And I am not logged in
      When I authenticate successfully with Facebook but Facebook does not return a usable email address
      Then I should be prompted to enter an email address
      When I enter a valid email address that has not been seen before
      Then I should be asked to go verify my email address
      When I click on the continue button after verifying my email address
      Then I should be signed in

    Scenario: An existing user connects to the site again
      Given I exist as a user
        And I am not logged in
        And I have been linked with Facebook
      When I authenticate successfully with Facebook and Facebook returns a usable email address
      Then I should be signed in

    Scenario: An existing user connect to the site again using a different identity
      Given I exist as a user
        And I am not logged in
        And I have been linked with Facebook
        And I have not been linked with Twitter
      When I authenticate successfully with Twitter and Twitter returns my email address
      Then I should be prompted to identify myself
      When I authenticate successfully with Facebook and Facebook returns a usable email address
      Then I should be signed in

    Scenario: An existing user connect to the site again using a different identity
      Given I exist as a user
        And I am not logged in
        And I have been linked with Facebook
        And I have not been linked with Twitter
      When I authenticate successfully with Twitter and Twitter returns my email address
      Then I should be prompted to identify myself
      When I enter valid credentials
      Then I should be signed in