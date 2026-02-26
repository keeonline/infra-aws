Feature: Call the infra endpoint fixed responses

Scenario: Show the baseUrl value
    * print baseUrl

Scenario: Call to a service that is not configured
    Given url baseUrl
    And path 'zulu/v1/greetings'
    When method GET
    Then status 503
    * match response.message == 'The service you have requested is unavailable' 