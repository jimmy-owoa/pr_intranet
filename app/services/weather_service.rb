class WeatherService
  def initialize
    # @api = "http://api.apixu.com/v1/forecast.json?key=19e45f0a4bdd4d929df131644191001&q="
    @api = "https://api.darksky.net/forecast/823d1b0355811c423649837dd9be5cab/"
  end

  def perform
    cities
    {
      antofagasta: @json_parse[0],
      santiago: @json_parse[1],
      copiapo: @json_parse[2],
      la_serena: @json_parse[3],
      vina_del_mar: @json_parse[4],
      rancagua: @json_parse[5],
      talca: @json_parse[6],
      concepcion: @json_parse[7],
      temuco: @json_parse[8],
      puerto_montt: @json_parse[9],
    }
  end

  def self.perform
    new.perform
  end

  def cities
    @cities = []
    @response = []
    @json_parse = []
    @cities << URI.parse(@api + "-23.6464,-70.398" + "?units=si")
    @cities << URI.parse(@api + "-33.4378,-70.6504" + "?units=si")
    @cities << URI.parse(@api + "-27.3665,-70.3323" + "?units=si")
    @cities << URI.parse(@api + "-29.9027,-71.252" + "?units=si")
    @cities << URI.parse(@api + "-33.0245,-71.5518" + "?units=si")
    @cities << URI.parse(@api + "-34.1702,-70.7407" + "?units=si")
    @cities << URI.parse(@api + "-35.4266,-71.6661" + "?units=si")
    @cities << URI.parse(@api + "-36.827,-73.0503" + "?units=si")
    @cities << URI.parse(@api + "-38.7362,-72.5906" + "?units=si")
    @cities << URI.parse(@api + "-41.4718,-72.9396" + "?units=si")

    @cities.each_with_index do |city, index|
      @response << Net::HTTP.get_response(city)
      @json_parse << JSON.parse(@response[index].body)
    end
  end
end
