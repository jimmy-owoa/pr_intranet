class IndicatorService
  def initialize
    uri = URI.parse("https://mindicador.cl/api")    
    response = Net::HTTP.get_response uri 
    @json_parse = JSON.parse(response.body) 
  end

  def perform
    {
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