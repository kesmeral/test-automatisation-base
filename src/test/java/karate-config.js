function fn() {
  var env = karate.env || 'local';
  
  // Configuración base para todos los entornos
  var config = {
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
  };
  
  // URLs para todos los microservicios (nombrados con formato port_nombre_microservicio)
  config.marvel_url = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  
  // Configuración específica por entorno
  if (env == 'dev') {
    config.baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
    config.marvel_url = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  } 
  else if (env == 'qa') {
    config.baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
    config.marvel_url = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  }
  
  return config;
}
