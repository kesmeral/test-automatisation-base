@REQ_kaesmera @HUkaesmera @gestion_personajes_marvel @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: kaesmera Gestión de personajes de Marvel (microservicio para CRUD de personajes)

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'kaesmera'
    * def basePath = '/' + username + '/api/characters'
    * configure ssl = true
    * def generarHeaders =
      """
      function() {
        return {
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers

  @id:1 @obtenerPersonajes @solicitudExitosa200
  Scenario: T-API-kaesmera-CA01-Obtener todos los personajes 200 - karate
    Given path basePath
    When method GET
    Then status 200    # And match response == '#array'
    # And match each response contains { id: '#number', name: '#string' }

  @id:2 @obtenerPersonajePorId @solicitudExitosa200
  Scenario: T-API-kaesmera-CA02-Obtener personaje por ID existente 200 - karate
    # Primero creamos un personaje para asegurar que existe
    * def uniqueName = 'Iron Man ' + Date.now()
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
    * set jsonData.name = uniqueName
    
    Given path basePath
    And request jsonData
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * def characterId = response.id
    
    # Ahora obtenemos el personaje por su ID
    Given path basePath + '/' + characterId
    When method GET
    Then status 200
    # And match response.id == characterId
    # And match response.name == uniqueName

  @id:3 @obtenerPersonajePorId @errorNoEncontrado404
  Scenario: T-API-kaesmera-CA03-Obtener personaje por ID inexistente 404 - karate
    Given path basePath + '/999999'
    When method GET
    Then status 404
    # And match response.error == 'Character not found'
    # And match response == { error: 'Character not found' }

  @id:4 @crearPersonaje @solicitudExitosa201
  Scenario: T-API-kaesmera-CA04-Crear personaje exitosamente 201 - karate
    # Generamos un nombre único usando timestamp para evitar conflictos
    * def timestamp = Date.now()
    * def uniqueName = 'Thor ' + timestamp
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
    * set jsonData.name = uniqueName
    
    Given path basePath
    And request jsonData
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    # And match response.id == '#number'
    # And match response.name == uniqueName

  @id:5 @crearPersonaje @errorNombreDuplicado400
  Scenario: T-API-kaesmera-CA05-Crear personaje con nombre duplicado 400 - karate
    # Primero creamos un personaje
    * def uniqueName = 'Captain America ' + Date.now()
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
    * set jsonData.name = uniqueName
    
    Given path basePath
    And request jsonData
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    
    # Intentamos crear otro con el mismo nombre
    Given path basePath
    And request jsonData
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    # And match response.error == 'Character name already exists'
    # And match response contains { error: '#string' }

  @id:6 @crearPersonaje @errorValidacion400
  Scenario: T-API-kaesmera-CA06-Crear personaje con campos requeridos faltantes 400 - karate
    Given path basePath
    And request read('classpath:data/marvel_characters_api/request_empty_character.json')
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    # And match response contains { name: 'Name is required' }
    # And match response contains { alterego: 'Alterego is required' }

  @id:7 @actualizarPersonaje @solicitudExitosa200
  Scenario: T-API-kaesmera-CA07-Actualizar personaje exitosamente 200 - karate
    # Primero creamos un personaje
    * def uniqueName = 'Black Widow ' + Date.now()
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
    * set jsonData.name = uniqueName
    
    Given path basePath
    And request jsonData
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * def characterId = response.id
    
    # Actualizamos el personaje
    * def updateData = read('classpath:data/marvel_characters_api/request_update_character.json')
    * set updateData.name = uniqueName
    * set updateData.description = "Master spy and assassin"
    
    Given path basePath + '/' + characterId
    And request updateData
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200
    # And match response.id == characterId
    # And match response.description == 'Master spy and assassin'

  @id:8 @actualizarPersonaje @errorNoEncontrado404
  Scenario: T-API-kaesmera-CA08-Actualizar personaje que no existe 404 - karate
    Given path basePath + '/999999'
    And request read('classpath:data/marvel_characters_api/request_update_character.json')
    And header Content-Type = 'application/json'
    When method PUT
    Then status 404
    # And match response.error == 'Character not found'
    # And match response contains { error: '#string' }

  @id:9 @eliminarPersonaje @solicitudExitosa204
  Scenario: T-API-kaesmera-CA09-Eliminar personaje exitosamente 204 - karate
    # Primero creamos un personaje
    * def uniqueName = 'Hulk ' + Date.now()
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
    * set jsonData.name = uniqueName
    
    Given path basePath
    And request jsonData
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * def characterId = response.id
    
    # Eliminamos el personaje
    Given path basePath + '/' + characterId
    When method DELETE
    Then status 204
    
    # Verificamos que ya no existe
    Given path basePath + '/' + characterId
    When method GET
    Then status 404
    # And match response.error == 'Character not found'
    # And match response contains { error: '#string' }

  @id:10 @eliminarPersonaje @errorNoEncontrado404
  Scenario: T-API-kaesmera-CA10-Eliminar personaje que no existe 404 - karate
    Given path basePath + '/999999'
    When method DELETE
    Then status 404
    # And match response.error == 'Character not found'
    # And match response contains { error: '#string' }

  @id:11 @errorServicio500
  Scenario: T-API-kaesmera-CA11-Error interno del servidor 500 - karate
    # Este escenario simula un error del servidor enviando una petición malformada
    * def malformedJson = '{"name": "Malformed'
    
    Given path basePath
    And request malformedJson
    And header Content-Type = 'application/json'
    When method POST
    Then status 500
    # And match response contains { error: '#string' }
    # And match response.status == 500
