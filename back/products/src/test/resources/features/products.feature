Feature: API Testing for Products

  Scenario: Create a new product without taxes
    * def baseUrl = karate.properties['baseUrl']
    * def product = { 'code': 'product-no-tax', 'name': 'Product No Tax', 'unitPrice': 10.0 }

    Given url baseUrl + '/organizations/org-1/products'
    And request product
    When method post
    Then status 201
    And match response.code == product.code
    And match response.name == product.name
    And match response.unitPrice == product.unitPrice
