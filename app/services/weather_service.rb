class WeatherService
  def initialize
    # @api = "http://api.apixu.com/v1/forecast.json?key=19e45f0a4bdd4d929df131644191001&q="
    @api = "https://api.darksky.net/forecast/1c7661eca9e3d51aa6911c335c5c9a1e/"
  end

  def perform
    cities
    {
      antofagasta: @json_parse[0],
      santiago: @json_parse[1],
      # copiapo: @json_parse[2],
      # la_serena: @json_parse[3],
      # vina_del_mar: @json_parse[4],
      # rancagua: @json_parse[5],
      # talca: @json_parse[6],
      # concepcion: @json_parse[7],
      # temuco: @json_parse[8],
      # puerto_montt: @json_parse[9],
    }
  end

  def self.perform
    new.perform
  end

  def cities
    @cities = []
    @response = []
    @json_parse = []
    @cities << URI.parse(@api+"-23.6464,-70.398"+"?units=si")
    @cities << URI.parse(@api+"-33.4378,-70.6504"+"?units=si")
    # @cities << URI.parse(@api+"Copiapo&days=1") 
    # @cities << URI.parse(@api+"La_Serena&days=1")
    # @cities << URI.parse(@api+"Vina_del_Mar&days=1")
    # @cities << URI.parse(@api+"Rancagua&days=1")
    # @cities << URI.parse(@api+"Talca&days=1")
    # @cities << URI.parse(@api+"Concepcion&days=1")
    # @cities << URI.parse(@api+"Temuco&days=1")
    # @cities << URI.parse(@api+"Puerto_Montt&days=1")
    
    @cities.each_with_index do |city, index|
      @response << Net::HTTP.get_response(city)
      @json_parse << JSON.parse(@response[index].body)
    end
  end

end