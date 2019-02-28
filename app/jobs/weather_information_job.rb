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
      location: 'Antofagasta', 
      date: @today,
      current_temp: @antofagasta['currently']['temperature'],
      condition: @antofagasta['currently']['summary'],
      icon: @antofagasta['currently']['icon'],
      max_temp: @antofagasta['daily']['data'][0]['temperatureMax'],
      min_temp: @antofagasta['daily']['data'][0]['temperatureMin']
    )
    General::WeatherInformation.where(id: 2).update_all(
      location: 'Santiago', 
      date: @today,
      current_temp: @santiago['currently']['temperature'],
      condition: @santiago['currently']['summary'],
      icon: @santiago['currently']['icon'],
      max_temp: @santiago['daily']['data'][0]['temperatureMax'],
      min_temp: @santiago['daily']['data'][0]['temperatureMin']
    )
    General::WeatherInformation.where(id: 3).update_all(
      location: 'Copiapo', 
      date: @today,
      current_temp: @copiapo['currently']['temperature'],
      condition: @copiapo['currently']['summary'],
      icon: @copiapo['currently']['icon'],
      max_temp: @copiapo['daily']['data'][0]['temperatureMax'],
      min_temp: @copiapo['daily']['data'][0]['temperatureMin'],
    )
    General::WeatherInformation.where(id: 4).update_all(
      location: 'La Serena', 
      date: @today,
      current_temp: @la_serena['currently']['temperature'],
      condition: @la_serena['currently']['summary'],
      icon: @la_serena['currently']['icon'],
      max_temp: @la_serena['daily']['data'][0]['temperatureMax'],
      min_temp: @la_serena['daily']['data'][0]['temperatureMin'],
    )
    General::WeatherInformation.where(id: 5).update_all(
      location: 'Viña del Mar', 
      date: @today,
      current_temp: @vina_del_mar['currently']['temperature'],
      condition: @vina_del_mar['currently']['summary'],
      icon: @vina_del_mar['currently']['icon'],
      max_temp: @vina_del_mar['daily']['data'][0]['temperatureMax'],
      min_temp: @vina_del_mar['daily']['data'][0]['temperatureMin'],
    )
    General::WeatherInformation.where(id: 6).update_all(
      location: 'Rancagua', 
      date: @today,
      current_temp: @rancagua['currently']['temperature'],
      condition: @rancagua['currently']['summary'],
      icon: @rancagua['currently']['icon'],
      max_temp: @rancagua['daily']['data'][0]['temperatureMax'],
      min_temp: @rancagua['daily']['data'][0]['temperatureMin'],
    )
    General::WeatherInformation.where(id: 7).update_all(
      location: 'Talca', 
      date: @today,
      current_temp: @talca['currently']['temperature'],
      condition: @talca['currently']['summary'],
      icon: @talca['currently']['icon'],
      max_temp: @talca['daily']['data'][0]['temperatureMax'],
      min_temp: @talca['daily']['data'][0]['temperatureMin'],
    )
    General::WeatherInformation.where(id: 8).update_all(
      location: 'Concepción', 
      date: @today,
      current_temp: @concepcion['currently']['temperature'],
      condition: @concepcion['currently']['summary'],
      icon: @concepcion['currently']['icon'],
      max_temp: @concepcion['daily']['data'][0]['temperatureMax'],
      min_temp: @concepcion['daily']['data'][0]['temperatureMin'],
    )
    General::WeatherInformation.where(id: 9).update_all(
      location: 'Temuco', 
      date: @today,
      current_temp: @temuco['currently']['temperature'],
      condition: @temuco['currently']['summary'],
      icon: @temuco['currently']['icon'],
      max_temp: @temuco['daily']['data'][0]['temperatureMax'],
      min_temp: @temuco['daily']['data'][0]['temperatureMin'],
    )
    General::WeatherInformation.where(id: 10).update_all(
      location: 'Puerto Montt', 
      date: @today,
      current_temp: @puerto_montt['currently']['temperature'],
      condition: @puerto_montt['currently']['summary'],
      icon: @puerto_montt['currently']['icon'],
      max_temp: @puerto_montt['daily']['data'][0]['temperatureMax'],
      min_temp: @puerto_montt['daily']['data'][0]['temperatureMin'],
    )    
  end

end