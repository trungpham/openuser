Feature: Sign In
  In order to get access to protected sections of the site
  As a user
  I want to be able to connect with this site using my existing existing identity

    Scenario: A brand new user connects to the site for the first time with a good email address
      Given I do not exist in the system
        And I am signed out
        And Facebook is a trusted identity provider
        And Facebook shares user's email address
      When I authenticate successfully with Facebook
      Then The system should create a new account for me
        And I should be authenticated

    Scenario: A brand new user connects to the site for the first time with a a bad or missing email address
      Given I do not exist in the system
        And I am signed out
        And Twitter is a trusted identity provider
        And Twitter does not share user's email address
      When I authenticate successfully with Twitter
      Then I should be prompted to enter my email address
      When I submit my email address
      Then I should be asked to go verify my email address
        And I verify my email address
      When I click on the continue button after verifying my email address
      Then The system should create a new account for me
        And I should be authenticated

    Scenario: A brand new user connects to the site for the first time using an unverified address
      Given I do not exist in the system
        And I am signed out
        And Github is a trusted identity provider
        And Github does not verify their user's email address
        And Github share user's email address
      When I authenticate successfully with Github
      Then I should be prompted to enter my email address
        And The email address should be prefilled
      When I submit my email address
      Then I should be asked to go verify my email address
        And I verify my email address
      When I click on the continue button after verifying my email address
      Then The system should create a new account for me
        And I should be authenticated

    Scenario: An existing user connects to the site again
      Given I exist as a user in the system
        And I am signed out
        And I have been linked with Facebook
      When I authenticate successfully with Facebook
      Then I should be authenticated

    Scenario: An existing user connects to the site again using a different identity and the email address matches then automatically link the user
      Given I exist as a user in the system
        And I am signed out
        And I have been linked with Facebook
        And I have not been linked with Google
        And Google shares user's email address
        And Google is a trusted identity provider
        And The email address given by Google matches my existing email address
      When I authenticate successfully with Google
      Then I should be authenticated

    Scenario: An existing user connects to the site again using a different identity. But the email address does not match so we offer him a chance to manually merge the account. And he wants to merge with his existing account.
      Given I exist as a user in the system
        And I am signed out
        But I have previously signed in from before
        And I have been linked with Facebook
        And I have not been linked with Google
        And Google shares user's email address
        And Google is a trusted identity provider
        But The email address given by Google does not match my existing email address
      When I authenticate successfully with Google
      Then I should be asked if I want to merge with my existing account
      Then I authenticate successfully with Facebook
      Then I should be authenticated

    Scenario: An existing user connects to the site again using a different identity. But the email address does not match so we offer him a chance to manually merge the account. But he refuses to merge with his existing account.
      Given I exist as a user in the system
        And I am signed out
        But I have previously signed in from before
        And I have been linked with Facebook
        And I have not been linked with Google
        And Google shares user's email address
        And Google is a trusted identity provider
        But The email address given by Google does not match my existing email address
      When I authenticate successfully with Google
      Then I should be asked if I want to merge with my existing account
      But I decline to merge my account
      Then The system should create a new account for me
        And I should be authenticated