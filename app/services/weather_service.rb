class WeatherService
  def initialize
    santiago = URI.parse("http://api.apixu.com/v1/forecast.json?key=19e45f0a4bdd4d929df131644191001&q=Santiago&days=1") 
    response = Net::HTTP.get_response santiago 
    @santiago = JSON.parse(response.body) 
  end

  def perform
    {
      # antofagasta: @santiago,
      santiago: @santiago,
      # copiapo: @santiago,
      # la_serena: @santiago,
      # vina_del_mar: @santiago,
      # rancagua: @santiago,
      # talca: @santiago,
      # concepcion: @santiago,
      # temuco: @santiago,
      # puerto_montt: @santiago
    }
  end

  def self.perform
    new.perform
  end

end