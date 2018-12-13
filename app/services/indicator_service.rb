class IndicatorService
  def initialize
    uri = URI.parse("http://indicadoresdeldia.cl/webservice/indicadores.json") 
    response = Net::HTTP.get_response uri 
    @json_parse = JSON.parse(response.body) 
  end

  def perform
    {
      santoral: @json_parse['santoral'],
      indicator: @json_parse['indicador'],
      stock: @json_parse['bolsa'],
      money: @json_parse['moneda'],
      restriction: @json_parse['restriccion']
    }
  end

  def self.perform
    new.perform
  end

end