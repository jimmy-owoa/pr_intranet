class IndicatorService
  require "uri"
  require "net/http"
  def initialize
    currencies_url = URI.parse("https://mindicador.cl/api")
    currencies_response = Net::HTTP.get_response currencies_url
    indexes_url = URI.parse("https://startup.bolsadesantiago.com/api/consulta/TickerOnDemand/getIndices?access_token=BB53BCF00EC1467BAB0254B041AF7692")
    http = Net::HTTP.new(indexes_url.host, indexes_url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # TEMPORALMENTE DEBIDO A QUE AL PARECER indexes_url TIENE PROBLEMAS CON EL CERTIFICADO SSL
    indexes_request = Net::HTTP::Post.new(indexes_url)
    indexes_response = http.request(indexes_request)
    @currencies = JSON.parse(currencies_response.body)
    @indexes = JSON.parse(indexes_response.read_body)
  end
  def perform
    {
      dolar: @currencies["dolar"]["valor"],
      euro: @currencies["euro"]["valor"],
      uf: @currencies["uf"]["valor"],
      utm: @currencies["utm"]["valor"],
      ipc: @currencies["ipc"]["valor"],
      ipsa: @indexes["listaResult"][1]["Valor"],
      ipsa_variation: @indexes["listaResult"][1]["Variacion"],
    }
  end
  def self.perform
    new.perform
  end
end