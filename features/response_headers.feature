Feature:  Response headers
  I want to put headers on my responses
  As a tester trying to test the application
  So that my application works with something close to my production server

  Scenario:  Disable caching
    Given I setup my replay service with no-cache
    When I make a request
    Then my response has a no-cache,no-store Cache-Control header

