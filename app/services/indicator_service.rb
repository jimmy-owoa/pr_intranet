class IndicatorService
  require 'net/http'
  require 'uri'
  require 'json'

  def initialize
    puts "******** Indicators service starts ********"

    api_key = '182b9b80025ca1041a53f639ab3b72b9a9db7ce2'

    url_indicators = [
      "https://api.sbif.cl/api-sbifv3/recursos_api/dolar?apikey=#{api_key}&formato=json",
      "https://api.sbif.cl/api-sbifv3/recursos_api/euro?apikey=#{api_key}&formato=json",
      "https://api.sbif.cl/api-sbifv3/recursos_api/uf?apikey=#{api_key}&formato=json",
      "https://api.sbif.cl/api-sbifv3/recursos_api/utm?apikey=#{api_key}&formato=json",
      "https://api.sbif.cl/api-sbifv3/recursos_api/ipc?apikey=#{api_key}&formato=json"
    ]

    @data = []
    url_indicators.each do |url|
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      @data << JSON.parse(response.body);
      puts "======= Indicator <#{uri.path}> passed succefully =======".green
    end
  end

  def perform
    {
      dolar: @data[0]["Dolares"][0]["Valor"],
      euro: @data[1]["Euros"][0]["Valor"],
      uf: @data[2]["UFs"][0]["Valor"],
      utm: @data[3]["UTMs"][0]["Valor"],
      ipc: @data[4]["IPCs"][0]["Valor"]
    }
  end

  def self.perform
    new.perform
  end

  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def green
    colorize(32)
  end
end