Feature:  Verify application's output
  I want to test that my application sends the correct requests to an external service
  As a tester trying to test the application
  So that I can verify my application independently of external services 

  Background:
    Given I setup my capture service

  Scenario:  Retrieve posts
    When I make 3 posts
    Then the service has received 3 posts

  Scenario Outline: HTTP methods
    When I do a <method> on "<endpoint>"
    Then the service has recieved a request on "<endpoint>"
    Examples:
      | method | endpoint |
      | POST   | /poster  |
      | PUT    | /putter  |

  Scenario Outline: HTTP methods
    When I do a <method> on "<endpoint>"
    Then the service has recieved a request on "<endpoint>"
    Examples:
      | method | endpoint |
      | PATCH  | /patcher |

  Scenario: Verifying headers
    When I do a POST on "/poster"
    #This is not an exhaustive list
    When the headers for the request on "/poster" should contain:
      | PATH_INFO       | /poster   |
      | QUERY_STRING    |           |
      | REQUEST_METHOD  | POST      |
      | SERVER_NAME     | 127.0.0.1 |
      | SERVER_PORT     | 9292      |
      | SERVER_PROTOCOL | HTTP/1.1  |
      | HTTP_VERSION    | HTTP/1.1  |
      | REQUEST_PATH    | /poster   |
