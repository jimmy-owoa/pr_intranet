class WeatherInformationJob < ApplicationJob
  queue_as :weather_information

  def perform(*args)
    @today =  Date.today.strftime("%d/%m/%Y")
    @tomorrow = (Date.today + 1.days).strftime("%A")
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
    General::WeatherInformation.create(
      location_id: General::Location.antofagasta.id, 
      date: @today,
      current_temp: @antofagasta['currently']['temperature'],
      condition: @antofagasta['currently']['summary'],
      icon: @antofagasta['currently']['icon'],
      uv_index: @santiago['currently']['uvIndex'].to_i,
      max_temp: @antofagasta['daily']['data'][0]['temperatureMax'],
      min_temp: @antofagasta['daily']['data'][0]['temperatureMin'],
      #######################
      tomorrow_max: @antofagasta['daily']['data'][1]['temperatureMax'].to_i,
      tomorrow_min: @antofagasta['daily']['data'][1]['temperatureMin'].to_i,
      tomorrow_icon: @antofagasta['daily']['data'][1]['icon'],
      after_tomorrow_max: @antofagasta['daily']['data'][2]['temperatureMax'].to_i,
      after_tomorrow_min: @antofagasta['daily']['data'][2]['temperatureMin'].to_i,
      after_tomorrow_icon: @antofagasta['daily']['data'][2]['icon'],
      aa_tomorrow_max: @antofagasta['daily']['data'][3]['temperatureMax'].to_i,
      aa_tomorrow_min: @antofagasta['daily']['data'][3]['temperatureMin'].to_i,
      aa_tomorrow_icon: @antofagasta['daily']['data'][3]['icon'],
      aaa_tomorrow_max: @antofagasta['daily']['data'][4]['temperatureMax'].to_i,
      aaa_tomorrow_min: @antofagasta['daily']['data'][4]['temperatureMin'].to_i,
      aaa_tomorrow_icon: @antofagasta['daily']['data'][4]['icon'],      
    )
    General::WeatherInformation.create(
      location_id: General::Location.santiago.id, 
      date: @today,
      current_temp: @santiago['currently']['temperature'].to_i,
      condition: @santiago['currently']['summary'],
      icon: @santiago['currently']['icon'],
      uv_index: @santiago['currently']['uvIndex'].to_i,
      max_temp: @santiago['daily']['data'][0]['temperatureMax'].to_i,
      min_temp: @santiago['daily']['data'][0]['temperatureMin'].to_i,
      #######################
      tomorrow_max: @santiago['daily']['data'][1]['temperatureMax'].to_i,
      tomorrow_min: @santiago['daily']['data'][1]['temperatureMin'].to_i,
      tomorrow_icon: @santiago['daily']['data'][1]['icon'],
      after_tomorrow_max: @santiago['daily']['data'][2]['temperatureMax'].to_i,
      after_tomorrow_min: @santiago['daily']['data'][2]['temperatureMin'].to_i,
      after_tomorrow_icon: @santiago['daily']['data'][2]['icon'],
      aa_tomorrow_max: @santiago['daily']['data'][3]['temperatureMax'].to_i,
      aa_tomorrow_min: @santiago['daily']['data'][3]['temperatureMin'].to_i,
      aa_tomorrow_icon: @santiago['daily']['data'][3]['icon'],
      aaa_tomorrow_max: @santiago['daily']['data'][4]['temperatureMax'].to_i,
      aaa_tomorrow_min: @santiago['daily']['data'][4]['temperatureMin'].to_i,
      aaa_tomorrow_icon: @santiago['daily']['data'][4]['icon'],
    )
    General::WeatherInformation.create(
      location_id: General::Location.copiapo.id, 
      date: @today,
      current_temp: @copiapo['currently']['temperature'],
      condition: @copiapo['currently']['summary'],
      icon: @copiapo['currently']['icon'],
      uv_index: @santiago['currently']['uvIndex'].to_i,
      max_temp: @copiapo['daily']['data'][0]['temperatureMax'],
      min_temp: @copiapo['daily']['data'][0]['temperatureMin'],
      #######################
      tomorrow_max: @copiapo['daily']['data'][1]['temperatureMax'].to_i,
      tomorrow_min: @copiapo['daily']['data'][1]['temperatureMin'].to_i,
      tomorrow_icon: @copiapo['daily']['data'][1]['icon'],
      after_tomorrow_max: @copiapo['daily']['data'][2]['temperatureMax'].to_i,
      after_tomorrow_min: @copiapo['daily']['data'][2]['temperatureMin'].to_i,
      after_tomorrow_icon: @copiapo['daily']['data'][2]['icon'],
      aa_tomorrow_max: @copiapo['daily']['data'][3]['temperatureMax'].to_i,
      aa_tomorrow_min: @copiapo['daily']['data'][3]['temperatureMin'].to_i,
      aa_tomorrow_icon: @copiapo['daily']['data'][3]['icon'],
      aaa_tomorrow_max: @copiapo['daily']['data'][4]['temperatureMax'].to_i,
      aaa_tomorrow_min: @copiapo['daily']['data'][4]['temperatureMin'].to_i,
      aaa_tomorrow_icon: @copiapo['daily']['data'][4]['icon'],      
    )
    General::WeatherInformation.create(
      location_id: General::Location.la_serena.id, 
      date: @today,
      current_temp: @la_serena['currently']['temperature'],
      condition: @la_serena['currently']['summary'],
      icon: @la_serena['currently']['icon'],
      uv_index: @santiago['currently']['uvIndex'].to_i,
      max_temp: @la_serena['daily']['data'][0]['temperatureMax'],
      min_temp: @la_serena['daily']['data'][0]['temperatureMin'],
      #######################
      tomorrow_max: @la_serena['daily']['data'][1]['temperatureMax'].to_i,
      tomorrow_min: @la_serena['daily']['data'][1]['temperatureMin'].to_i,
      tomorrow_icon: @la_serena['daily']['data'][1]['icon'],
      after_tomorrow_max: @la_serena['daily']['data'][2]['temperatureMax'].to_i,
      after_tomorrow_min: @la_serena['daily']['data'][2]['temperatureMin'].to_i,
      after_tomorrow_icon: @la_serena['daily']['data'][2]['icon'],
      aa_tomorrow_max: @la_serena['daily']['data'][3]['temperatureMax'].to_i,
      aa_tomorrow_min: @la_serena['daily']['data'][3]['temperatureMin'].to_i,
      aa_tomorrow_icon: @la_serena['daily']['data'][3]['icon'],
      aaa_tomorrow_max: @la_serena['daily']['data'][4]['temperatureMax'].to_i,
      aaa_tomorrow_min: @la_serena['daily']['data'][4]['temperatureMin'].to_i,
      aaa_tomorrow_icon: @la_serena['daily']['data'][4]['icon'],      
    )
    General::WeatherInformation.create(
      location_id: General::Location.vina_del_mar.id, 
      date: @today,
      current_temp: @vina_del_mar['currently']['temperature'],
      condition: @vina_del_mar['currently']['summary'],
      icon: @vina_del_mar['currently']['icon'],
      uv_index: @santiago['currently']['uvIndex'].to_i,
      max_temp: @vina_del_mar['daily']['data'][0]['temperatureMax'],
      min_temp: @vina_del_mar['daily']['data'][0]['temperatureMin'],
      #######################
      tomorrow_max: @vina_del_mar['daily']['data'][1]['temperatureMax'].to_i,
      tomorrow_min: @vina_del_mar['daily']['data'][1]['temperatureMin'].to_i,
      tomorrow_icon: @vina_del_mar['daily']['data'][1]['icon'],
      after_tomorrow_max: @vina_del_mar['daily']['data'][2]['temperatureMax'].to_i,
      after_tomorrow_min: @vina_del_mar['daily']['data'][2]['temperatureMin'].to_i,
      after_tomorrow_icon: @vina_del_mar['daily']['data'][2]['icon'],
      aa_tomorrow_max: @vina_del_mar['daily']['data'][3]['temperatureMax'].to_i,
      aa_tomorrow_min: @vina_del_mar['daily']['data'][3]['temperatureMin'].to_i,
      aa_tomorrow_icon: @vina_del_mar['daily']['data'][3]['icon'],
      aaa_tomorrow_max: @vina_del_mar['daily']['data'][4]['temperatureMax'].to_i,
      aaa_tomorrow_min: @vina_del_mar['daily']['data'][4]['temperatureMin'].to_i,
      aaa_tomorrow_icon: @vina_del_mar['daily']['data'][4]['icon'],      
    )
    General::WeatherInformation.create(
      location_id: General::Location.rancagua.id, 
      date: @today,
      current_temp: @rancagua['currently']['temperature'],
      condition: @rancagua['currently']['summary'],
      icon: @rancagua['currently']['icon'],
      uv_index: @santiago['currently']['uvIndex'].to_i,
      max_temp: @rancagua['daily']['data'][0]['temperatureMax'],
      min_temp: @rancagua['daily']['data'][0]['temperatureMin'],
      #######################
      tomorrow_max: @rancagua['daily']['data'][1]['temperatureMax'].to_i,
      tomorrow_min: @rancagua['daily']['data'][1]['temperatureMin'].to_i,
      tomorrow_icon: @rancagua['daily']['data'][1]['icon'],
      after_tomorrow_max: @rancagua['daily']['data'][2]['temperatureMax'].to_i,
      after_tomorrow_min: @rancagua['daily']['data'][2]['temperatureMin'].to_i,
      after_tomorrow_icon: @rancagua['daily']['data'][2]['icon'],
      aa_tomorrow_max: @rancagua['daily']['data'][3]['temperatureMax'].to_i,
      aa_tomorrow_min: @rancagua['daily']['data'][3]['temperatureMin'].to_i,
      aa_tomorrow_icon: @rancagua['daily']['data'][3]['icon'],
      aaa_tomorrow_max: @rancagua['daily']['data'][4]['temperatureMax'].to_i,
      aaa_tomorrow_min: @rancagua['daily']['data'][4]['temperatureMin'].to_i,
      aaa_tomorrow_icon: @rancagua['daily']['data'][4]['icon'],      
    )
    General::WeatherInformation.create(
      location_id: General::Location.talca.id, 
      date: @today,
      current_temp: @talca['currently']['temperature'],
      condition: @talca['currently']['summary'],
      icon: @talca['currently']['icon'],
      uv_index: @santiago['currently']['uvIndex'].to_i,
      max_temp: @talca['daily']['data'][0]['temperatureMax'],
      min_temp: @talca['daily']['data'][0]['temperatureMin'],
      #######################
      tomorrow_max: @talca['daily']['data'][1]['temperatureMax'].to_i,
      tomorrow_min: @talca['daily']['data'][1]['temperatureMin'].to_i,
      tomorrow_icon: @talca['daily']['data'][1]['icon'],
      after_tomorrow_max: @talca['daily']['data'][2]['temperatureMax'].to_i,
      after_tomorrow_min: @talca['daily']['data'][2]['temperatureMin'].to_i,
      after_tomorrow_icon: @talca['daily']['data'][2]['icon'],
      aa_tomorrow_max: @talca['daily']['data'][3]['temperatureMax'].to_i,
      aa_tomorrow_min: @talca['daily']['data'][3]['temperatureMin'].to_i,
      aa_tomorrow_icon: @talca['daily']['data'][3]['icon'],
      aaa_tomorrow_max: @talca['daily']['data'][4]['temperatureMax'].to_i,
      aaa_tomorrow_min: @talca['daily']['data'][4]['temperatureMin'].to_i,
      aaa_tomorrow_icon: @talca['daily']['data'][4]['icon'],      
    )
    General::WeatherInformation.create(
      location_id: General::Location.concepcion.id, 
      date: @today,
      current_temp: @concepcion['currently']['temperature'],
      condition: @concepcion['currently']['summary'],
      icon: @concepcion['currently']['icon'],
      uv_index: @santiago['currently']['uvIndex'].to_i,
      max_temp: @concepcion['daily']['data'][0]['temperatureMax'],
      min_temp: @concepcion['daily']['data'][0]['temperatureMin'],
      #######################
      tomorrow_max: @concepcion['daily']['data'][1]['temperatureMax'].to_i,
      tomorrow_min: @concepcion['daily']['data'][1]['temperatureMin'].to_i,
      tomorrow_icon: @concepcion['daily']['data'][1]['icon'],
      after_tomorrow_max: @concepcion['daily']['data'][2]['temperatureMax'].to_i,
      after_tomorrow_min: @concepcion['daily']['data'][2]['temperatureMin'].to_i,
      after_tomorrow_icon: @concepcion['daily']['data'][2]['icon'],
      aa_tomorrow_max: @concepcion['daily']['data'][3]['temperatureMax'].to_i,
      aa_tomorrow_min: @concepcion['daily']['data'][3]['temperatureMin'].to_i,
      aa_tomorrow_icon: @concepcion['daily']['data'][3]['icon'],
      aaa_tomorrow_max: @concepcion['daily']['data'][4]['temperatureMax'].to_i,
      aaa_tomorrow_min: @concepcion['daily']['data'][4]['temperatureMin'].to_i,
      aaa_tomorrow_icon: @concepcion['daily']['data'][4]['icon'],      
    )
    General::WeatherInformation.create(
      location_id: General::Location.temuco.id, 
      date: @today,
      current_temp: @temuco['currently']['temperature'],
      condition: @temuco['currently']['summary'],
      icon: @temuco['currently']['icon'],
      uv_index: @santiago['currently']['uvIndex'].to_i,
      max_temp: @temuco['daily']['data'][0]['temperatureMax'],
      min_temp: @temuco['daily']['data'][0]['temperatureMin'],
      #######################
      tomorrow_max: @temuco['daily']['data'][1]['temperatureMax'].to_i,
      tomorrow_min: @temuco['daily']['data'][1]['temperatureMin'].to_i,
      tomorrow_icon: @temuco['daily']['data'][1]['icon'],
      after_tomorrow_max: @temuco['daily']['data'][2]['temperatureMax'].to_i,
      after_tomorrow_min: @temuco['daily']['data'][2]['temperatureMin'].to_i,
      after_tomorrow_icon: @temuco['daily']['data'][2]['icon'],
      aa_tomorrow_max: @temuco['daily']['data'][3]['temperatureMax'].to_i,
      aa_tomorrow_min: @temuco['daily']['data'][3]['temperatureMin'].to_i,
      aa_tomorrow_icon: @temuco['daily']['data'][3]['icon'],
      aaa_tomorrow_max: @temuco['daily']['data'][4]['temperatureMax'].to_i,
      aaa_tomorrow_min: @temuco['daily']['data'][4]['temperatureMin'].to_i,
      aaa_tomorrow_icon: @temuco['daily']['data'][4]['icon'],      
    )
    General::WeatherInformation.create(
      location_id: General::Location.puerto_montt.id, 
      date: @today,
      current_temp: @puerto_montt['currently']['temperature'],
      condition: @puerto_montt['currently']['summary'],
      icon: @puerto_montt['currently']['icon'],
      uv_index: @santiago['currently']['uvIndex'].to_i,
      max_temp: @puerto_montt['daily']['data'][0]['temperatureMax'],
      min_temp: @puerto_montt['daily']['data'][0]['temperatureMin'],
      #######################
      tomorrow_max: @puerto_montt['daily']['data'][1]['temperatureMax'].to_i,
      tomorrow_min: @puerto_montt['daily']['data'][1]['temperatureMin'].to_i,
      tomorrow_icon: @puerto_montt['daily']['data'][1]['icon'],
      after_tomorrow_max: @puerto_montt['daily']['data'][2]['temperatureMax'].to_i,
      after_tomorrow_min: @puerto_montt['daily']['data'][2]['temperatureMin'].to_i,
      after_tomorrow_icon: @puerto_montt['daily']['data'][2]['icon'],
      aa_tomorrow_max: @puerto_montt['daily']['data'][3]['temperatureMax'].to_i,
      aa_tomorrow_min: @puerto_montt['daily']['data'][3]['temperatureMin'].to_i,
      aa_tomorrow_icon: @puerto_montt['daily']['data'][3]['icon'],
      aaa_tomorrow_max: @puerto_montt['daily']['data'][4]['temperatureMax'].to_i,
      aaa_tomorrow_min: @puerto_montt['daily']['data'][4]['temperatureMin'].to_i,
      aaa_tomorrow_icon: @puerto_montt['daily']['data'][4]['icon'],      
    )    
  end

end