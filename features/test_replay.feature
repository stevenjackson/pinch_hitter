Feature:  Test WS replay
  I want to test the ability to return a web service call on demand
  As a tester trying to test the application
  So that I can control my test data

  Background:
    Given I setup my replay service

  Scenario:  Simple replay
    Given I want a car rental
    When I make a reservation
    Then I see a car reservation

  Scenario:  Replay with subsititution
    Given I want a car rental with a "City" of "ATL"
    When I make a reservation
    Then I see a car reservation with a "City" of "ATL"

  Scenario:  Replay with json
    Given I want to lookup a definition
    When I query the glossary
    Then I see a definition

  Scenario:  Replay with json substituion
    Given I want to lookup a definition with a "ID" of "FOO"
    When I query the glossary
    Then I see a definition with a "ID" of "FOO"

  Scenario Outline:  Replay with custom module
    Given I want to do some fancy processing
    When I query my service with <request>
    Then I see <response> in the service response

    Examples:
      |request| response   |
      |ABC    | 123        |
      |DEF    | Comedy Jam |

  Scenario:  Retrieve posts
    Given I want a car rental
    When I make a reservation
    Then the service has received 1 reservation

  Scenario:  Retrieve multiple posts
    Given I want 3 car rentals
    When I make 3 reservations
    Then the service has received 3 reservations

