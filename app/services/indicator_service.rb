class IndicatorService
  require 'uri'
  require 'net/http'
  def initialize
    currencies_url = URI.parse("https://mindicador.cl/api")
    currencies_response = Net::HTTP.get_response currencies_url

    indexes_url = URI("http://startup.bolsadesantiago.com/api/consulta/TickerOnDemand/getIndices?access_token=BB53BCF00EC1467BAB0254B041AF7692")
    http = Net::HTTP.new(indexes_url.host, indexes_url.port)
    indexes_request = Net::HTTP::Post.new(indexes_url)
    indexes_response = http.request(indexes_request)
    @currencies = JSON.parse(currencies_response.body)
    puts @currencies
    @indexes = JSON.parse(indexes_response.read_body)
    puts @indexes
  end
  
  def perform
    {
      dolar: @currencies['dolar']['valor'],
      euro: @currencies['euro']['valor'],
      uf: @currencies['uf']['valor'],
      utm: @currencies['utm']['valor'],
      ipc: @currencies['ipc']['valor'],
      ipsa: @indexes['listaResult'][1]['Valor']
    }
  end

  def self.perform
    new.perform
  end

end