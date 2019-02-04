class IndicatorService
  def initialize
    # uri = URI.parse("http://indicadoresdeldia.cl/webservice/indicadores.json") 
    uri = URI.parse("https://mindicador.cl/api")    
    response = Net::HTTP.get_response uri 
    @json_parse = JSON.parse(response.body) 
  end

  def perform
    {
      # santoral: @json_parse['santoral'],
      # indicator: @json_parse['indicador'],
      # stock: @json_parse['bolsa'],
      # money: @json_parse['moneda'],
      # restriction: @json_parse['restriccion']
      santoral: 'en revisión',
      dolar: @json_parse['dolar']['valor'],
      euro: @json_parse['euro']['valor'],
      uf: @json_parse['uf']['valor'],
      utm: @json_parse['utm']['valor'],
      ipc: @json_parse['ipc']['valor']
    }
  end

  def self.perform
    new.perform
  end

end