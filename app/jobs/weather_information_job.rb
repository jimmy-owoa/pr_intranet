class WeatherInformationJob < ApplicationJob
  queue_as :weather_information

  def perform(*args)
    @today =  Date.today.strftime("%d/%m/%Y")
    @antofagasta = WeatherService.perform[:antofagasta]
    @santiago = WeatherService.perform[:santiago]
    @copiapo = WeatherService.perform[:copiapo]
    @la_serena= WeatherService.perform[:la_serena]
    @vina_del_mar = WeatherService.perform[:vina_del_mar]
    @rancagua = WeatherService.perform[:rancagua]
    @talca = WeatherService.perform[:talca]
    @concepcion = WeatherService.perform[:concepcion]
    @temuco = WeatherService.perform[:temuco]
    @puerto_montt = WeatherService.perform[:puerto_montt]
    set_weather
  end

  def set_weather
    #save data
    General::WeatherInformation.where(id: 1).update_all(
      location: @antofagasta['location']['name'], 
      date: @today,
      current_temp: @antofagasta['current']['temp_c'],
      condition: @antofagasta['current']['condition']['text'],
      icon: @antofagasta['current']['condition']['icon'],
      max_temp: @antofagasta['forecast']['forecastday'][0]['day']['maxtemp_c'],
      min_temp: @antofagasta['forecast']['forecastday'][0]['day']['mintemp_c'],
    )
    General::WeatherInformation.where(id: 2).update_all(
      location: @santiago['location']['name'], 
      date: @today,
      current_temp: @santiago['current']['temp_c'],
      condition: @santiago['current']['condition']['text'],
      icon: @santiago['current']['condition']['icon'],
      max_temp: @santiago['forecast']['forecastday'][0]['day']['maxtemp_c'],
      min_temp: @santiago['forecast']['forecastday'][0]['day']['mintemp_c'],
    )
    General::WeatherInformation.where(id: 3).update_all(
      location: @copiapo['location']['name'], 
      date: @today,
      current_temp: @copiapo['current']['temp_c'],
      condition: @copiapo['current']['condition']['text'],
      icon: @copiapo['current']['condition']['icon'],
      max_temp: @copiapo['forecast']['forecastday'][0]['day']['maxtemp_c'],
      min_temp: @copiapo['forecast']['forecastday'][0]['day']['mintemp_c'],
    )
    General::WeatherInformation.where(id: 4).update_all(
      location: @la_serena['location']['name'], 
      date: @today,
      current_temp: @la_serena['current']['temp_c'],
      condition: @la_serena['current']['condition']['text'],
      icon: @la_serena['current']['condition']['icon'],
      max_temp: @la_serena['forecast']['forecastday'][0]['day']['maxtemp_c'],
      min_temp: @la_serena['forecast']['forecastday'][0]['day']['mintemp_c'],
    )
    General::WeatherInformation.where(id: 5).update_all(
      location: @vina_del_mar['location']['name'], 
      date: @today,
      current_temp: @vina_del_mar['current']['temp_c'],
      condition: @vina_del_mar['current']['condition']['text'],
      icon: @vina_del_mar['current']['condition']['icon'],
      max_temp: @vina_del_mar['forecast']['forecastday'][0]['day']['maxtemp_c'],
      min_temp: @vina_del_mar['forecast']['forecastday'][0]['day']['mintemp_c'],
    )
    General::WeatherInformation.where(id: 6).update_all(
      location: @rancagua['location']['name'], 
      date: @today,
      current_temp: @rancagua['current']['temp_c'],
      condition: @rancagua['current']['condition']['text'],
      icon: @rancagua['current']['condition']['icon'],
      max_temp: @rancagua['forecast']['forecastday'][0]['day']['maxtemp_c'],
      min_temp: @rancagua['forecast']['forecastday'][0]['day']['mintemp_c'],
    )
    General::WeatherInformation.where(id: 7).update_all(
      location: @talca['location']['name'], 
      date: @today,
      current_temp: @talca['current']['temp_c'],
      condition: @talca['current']['condition']['text'],
      icon: @talca['current']['condition']['icon'],
      max_temp: @talca['forecast']['forecastday'][0]['day']['maxtemp_c'],
      min_temp: @talca['forecast']['forecastday'][0]['day']['mintemp_c'],
    )
    General::WeatherInformation.where(id: 8).update_all(
      location: @concepcion['location']['name'], 
      date: @today,
      current_temp: @concepcion['current']['temp_c'],
      condition: @concepcion['current']['condition']['text'],
      icon: @concepcion['current']['condition']['icon'],
      max_temp: @concepcion['forecast']['forecastday'][0]['day']['maxtemp_c'],
      min_temp: @concepcion['forecast']['forecastday'][0]['day']['mintemp_c'],
    )
    General::WeatherInformation.where(id: 9).update_all(
      location: @temuco['location']['name'], 
      date: @today,
      current_temp: @temuco['current']['temp_c'],
      condition: @temuco['current']['condition']['text'],
      icon: @temuco['current']['condition']['icon'],
      max_temp: @temuco['forecast']['forecastday'][0]['day']['maxtemp_c'],
      min_temp: @temuco['forecast']['forecastday'][0]['day']['mintemp_c'],
    )
    General::WeatherInformation.where(id: 10).update_all(
      location: @puerto_montt['location']['name'], 
      date: @today,
      current_temp: @puerto_montt['current']['temp_c'],
      condition: @puerto_montt['current']['condition']['text'],
      icon: @puerto_montt['current']['condition']['icon'],
      max_temp: @puerto_montt['forecast']['forecastday'][0]['day']['maxtemp_c'],
      min_temp: @puerto_montt['forecast']['forecastday'][0]['day']['mintemp_c'],
    )    
  end

end