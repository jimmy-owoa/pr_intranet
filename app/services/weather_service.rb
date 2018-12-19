class WeatherService
  def initialize
    uri = URI.parse("http://api.openweathermap.org/data/2.5/group?id=3899537,3873544,3893656,6356011,3868121,3873775,3870294,3893894,3870011,3874960&units=metric&APPID=1c045779fe960f1ff5a2112d54049438&lang=es") 
    response = Net::HTTP.get_response uri 
    @json_parse = JSON.parse(response.body) 
  end

  def perform
    {
      antofagasta: @json_parse['list'][0],
      santiago: @json_parse['list'][1],
      copiapo: @json_parse['list'][2],
      la_serena: @json_parse['list'][3],
      vina_del_mar: @json_parse['list'][4],
      rancagua: @json_parse['list'][5],
      talca: @json_parse['list'][6],
      concepcion: @json_parse['list'][7],
      temuco: @json_parse['list'][8],
      puerto_montt: @json_parse['list'][9],

    }
  end

  def self.perform
    new.perform
  end

end