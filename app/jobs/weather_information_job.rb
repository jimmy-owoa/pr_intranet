class WeatherInformationJob < ApplicationJob
  queue_as :weather_information

  def perform(*args)
    @today = Date.today.strftime("%d/%m/%Y")
    @tomorrow = (Date.today + 1.days).strftime("%A")
    puts "Getting weather information from DARKSKY API...".green
    if @weather = WeatherService.perform
      puts "Data passed succefully from DARKSKY API.".green
    else
      puts "Error!!!!".red
    end
    set_weather
  end

  def set_weather
    if @weather[:santiago]["error"].present?
      puts "Error en el llamado a la api darksky.net: " + @weather[:santiago]["error"]
    end
    #save data
    location = General::Location.antofagasta
    puts "Saving data information for #{location.name}..."
    General::WeatherInformation.create(
      location_id: location.id,
      date: @today,
      current_temp: @weather[:antofagasta]["currently"]["temperature"],
      condition: @weather[:antofagasta]["currently"]["summary"],
      icon: @weather[:antofagasta]["currently"]["icon"],
      uv_index: @weather[:antofagasta]["currently"]["uvIndex"].to_i,
      max_temp: @weather[:antofagasta]["daily"]["data"][0]["temperatureMax"],
      min_temp: @weather[:antofagasta]["daily"]["data"][0]["temperatureMin"],
      tomorrow_max: @weather[:antofagasta]["daily"]["data"][1]["temperatureMax"].to_i,
      tomorrow_min: @weather[:antofagasta]["daily"]["data"][1]["temperatureMin"].to_i,
      tomorrow_icon: @weather[:antofagasta]["daily"]["data"][1]["icon"],
      after_tomorrow_max: @weather[:antofagasta]["daily"]["data"][2]["temperatureMax"].to_i,
      after_tomorrow_min: @weather[:antofagasta]["daily"]["data"][2]["temperatureMin"].to_i,
      after_tomorrow_icon: @weather[:antofagasta]["daily"]["data"][2]["icon"],
      aa_tomorrow_max: @weather[:antofagasta]["daily"]["data"][3]["temperatureMax"].to_i,
      aa_tomorrow_min: @weather[:antofagasta]["daily"]["data"][3]["temperatureMin"].to_i,
      aa_tomorrow_icon: @weather[:antofagasta]["daily"]["data"][3]["icon"],
      aaa_tomorrow_max: @weather[:antofagasta]["daily"]["data"][4]["temperatureMax"].to_i,
      aaa_tomorrow_min: @weather[:antofagasta]["daily"]["data"][4]["temperatureMin"].to_i,
      aaa_tomorrow_icon: @weather[:antofagasta]["daily"]["data"][4]["icon"],
    )
    puts "New record saved. Location: #{location.name} at #{Time.now}".green
    location = General::Location.santiago
    puts "Saving data information for #{location.name}..."
    General::WeatherInformation.create(
      location_id: location.id,
      date: @today,
      current_temp: @weather[:santiago]["currently"]["temperature"].to_i,
      condition: @weather[:santiago]["currently"]["summary"],
      icon: @weather[:santiago]["currently"]["icon"],
      uv_index: @weather[:santiago]["currently"]["uvIndex"].to_i,
      max_temp: @weather[:santiago]["daily"]["data"][0]["temperatureMax"].to_i,
      min_temp: @weather[:santiago]["daily"]["data"][0]["temperatureMin"].to_i,
      tomorrow_max: @weather[:santiago]["daily"]["data"][1]["temperatureMax"].to_i,
      tomorrow_min: @weather[:santiago]["daily"]["data"][1]["temperatureMin"].to_i,
      tomorrow_icon: @weather[:santiago]["daily"]["data"][1]["icon"],
      after_tomorrow_max: @weather[:santiago]["daily"]["data"][2]["temperatureMax"].to_i,
      after_tomorrow_min: @weather[:santiago]["daily"]["data"][2]["temperatureMin"].to_i,
      after_tomorrow_icon: @weather[:santiago]["daily"]["data"][2]["icon"],
      aa_tomorrow_max: @weather[:santiago]["daily"]["data"][3]["temperatureMax"].to_i,
      aa_tomorrow_min: @weather[:santiago]["daily"]["data"][3]["temperatureMin"].to_i,
      aa_tomorrow_icon: @weather[:santiago]["daily"]["data"][3]["icon"],
      aaa_tomorrow_max: @weather[:santiago]["daily"]["data"][4]["temperatureMax"].to_i,
      aaa_tomorrow_min: @weather[:santiago]["daily"]["data"][4]["temperatureMin"].to_i,
      aaa_tomorrow_icon: @weather[:santiago]["daily"]["data"][4]["icon"],
    )
    puts "New record saved. Location: #{location.name} at #{Time.now}".green
    location = General::Location.copiapo
    puts "Saving data information for #{location.name}..."
    General::WeatherInformation.create(
      location_id: location.id,
      date: @today,
      current_temp: @weather[:copiapo]["currently"]["temperature"],
      condition: @weather[:copiapo]["currently"]["summary"],
      icon: @weather[:copiapo]["currently"]["icon"],
      uv_index: @weather[:copiapo]["currently"]["uvIndex"].to_i,
      max_temp: @weather[:copiapo]["daily"]["data"][0]["temperatureMax"],
      min_temp: @weather[:copiapo]["daily"]["data"][0]["temperatureMin"],
      tomorrow_max: @weather[:copiapo]["daily"]["data"][1]["temperatureMax"].to_i,
      tomorrow_min: @weather[:copiapo]["daily"]["data"][1]["temperatureMin"].to_i,
      tomorrow_icon: @weather[:copiapo]["daily"]["data"][1]["icon"],
      after_tomorrow_max: @weather[:copiapo]["daily"]["data"][2]["temperatureMax"].to_i,
      after_tomorrow_min: @weather[:copiapo]["daily"]["data"][2]["temperatureMin"].to_i,
      after_tomorrow_icon: @weather[:copiapo]["daily"]["data"][2]["icon"],
      aa_tomorrow_max: @weather[:copiapo]["daily"]["data"][3]["temperatureMax"].to_i,
      aa_tomorrow_min: @weather[:copiapo]["daily"]["data"][3]["temperatureMin"].to_i,
      aa_tomorrow_icon: @weather[:copiapo]["daily"]["data"][3]["icon"],
      aaa_tomorrow_max: @weather[:copiapo]["daily"]["data"][4]["temperatureMax"].to_i,
      aaa_tomorrow_min: @weather[:copiapo]["daily"]["data"][4]["temperatureMin"].to_i,
      aaa_tomorrow_icon: @weather[:copiapo]["daily"]["data"][4]["icon"],
    )
    puts "New record saved. Location: #{location.name} at #{Time.now}".green
    location = General::Location.la_serena
    puts "Saving data information for #{location.name}..."
    General::WeatherInformation.create(
      location_id: location.id,
      date: @today,
      current_temp: @weather[:la_serena]["currently"]["temperature"],
      condition: @weather[:la_serena]["currently"]["summary"],
      icon: @weather[:la_serena]["currently"]["icon"],
      uv_index: @weather[:la_serena]["currently"]["uvIndex"].to_i,
      max_temp: @weather[:la_serena]["daily"]["data"][0]["temperatureMax"],
      min_temp: @weather[:la_serena]["daily"]["data"][0]["temperatureMin"],
      tomorrow_max: @weather[:la_serena]["daily"]["data"][1]["temperatureMax"].to_i,
      tomorrow_min: @weather[:la_serena]["daily"]["data"][1]["temperatureMin"].to_i,
      tomorrow_icon: @weather[:la_serena]["daily"]["data"][1]["icon"],
      after_tomorrow_max: @weather[:la_serena]["daily"]["data"][2]["temperatureMax"].to_i,
      after_tomorrow_min: @weather[:la_serena]["daily"]["data"][2]["temperatureMin"].to_i,
      after_tomorrow_icon: @weather[:la_serena]["daily"]["data"][2]["icon"],
      aa_tomorrow_max: @weather[:la_serena]["daily"]["data"][3]["temperatureMax"].to_i,
      aa_tomorrow_min: @weather[:la_serena]["daily"]["data"][3]["temperatureMin"].to_i,
      aa_tomorrow_icon: @weather[:la_serena]["daily"]["data"][3]["icon"],
      aaa_tomorrow_max: @weather[:la_serena]["daily"]["data"][4]["temperatureMax"].to_i,
      aaa_tomorrow_min: @weather[:la_serena]["daily"]["data"][4]["temperatureMin"].to_i,
      aaa_tomorrow_icon: @weather[:la_serena]["daily"]["data"][4]["icon"],
    )
    puts "New record saved. Location: #{location.name} at #{Time.now}".green
    location = General::Location.vina_del_mar
    puts "Saving data information for #{location.name}..."
    General::WeatherInformation.create(
      location_id: location.id,
      date: @today,
      current_temp: @weather[:vina_del_mar]["currently"]["temperature"],
      condition: @weather[:vina_del_mar]["currently"]["summary"],
      icon: @weather[:vina_del_mar]["currently"]["icon"],
      uv_index: @weather[:vina_del_mar]["currently"]["uvIndex"].to_i,
      max_temp: @weather[:vina_del_mar]["daily"]["data"][0]["temperatureMax"],
      min_temp: @weather[:vina_del_mar]["daily"]["data"][0]["temperatureMin"],
      tomorrow_max: @weather[:vina_del_mar]["daily"]["data"][1]["temperatureMax"].to_i,
      tomorrow_min: @weather[:vina_del_mar]["daily"]["data"][1]["temperatureMin"].to_i,
      tomorrow_icon: @weather[:vina_del_mar]["daily"]["data"][1]["icon"],
      after_tomorrow_max: @weather[:vina_del_mar]["daily"]["data"][2]["temperatureMax"].to_i,
      after_tomorrow_min: @weather[:vina_del_mar]["daily"]["data"][2]["temperatureMin"].to_i,
      after_tomorrow_icon: @weather[:vina_del_mar]["daily"]["data"][2]["icon"],
      aa_tomorrow_max: @weather[:vina_del_mar]["daily"]["data"][3]["temperatureMax"].to_i,
      aa_tomorrow_min: @weather[:vina_del_mar]["daily"]["data"][3]["temperatureMin"].to_i,
      aa_tomorrow_icon: @weather[:vina_del_mar]["daily"]["data"][3]["icon"],
      aaa_tomorrow_max: @weather[:vina_del_mar]["daily"]["data"][4]["temperatureMax"].to_i,
      aaa_tomorrow_min: @weather[:vina_del_mar]["daily"]["data"][4]["temperatureMin"].to_i,
      aaa_tomorrow_icon: @weather[:vina_del_mar]["daily"]["data"][4]["icon"],
    )
    puts "New record saved. Location: #{location.name} at #{Time.now}".green
    location = General::Location.rancagua
    puts "Saving data information for #{location.name}..."
    General::WeatherInformation.create(
      location_id: location.id,
      date: @today,
      current_temp: @weather[:rancagua]["currently"]["temperature"],
      condition: @weather[:rancagua]["currently"]["summary"],
      icon: @weather[:rancagua]["currently"]["icon"],
      uv_index: @weather[:rancagua]["currently"]["uvIndex"].to_i,
      max_temp: @weather[:rancagua]["daily"]["data"][0]["temperatureMax"],
      min_temp: @weather[:rancagua]["daily"]["data"][0]["temperatureMin"],
      tomorrow_max: @weather[:rancagua]["daily"]["data"][1]["temperatureMax"].to_i,
      tomorrow_min: @weather[:rancagua]["daily"]["data"][1]["temperatureMin"].to_i,
      tomorrow_icon: @weather[:rancagua]["daily"]["data"][1]["icon"],
      after_tomorrow_max: @weather[:rancagua]["daily"]["data"][2]["temperatureMax"].to_i,
      after_tomorrow_min: @weather[:rancagua]["daily"]["data"][2]["temperatureMin"].to_i,
      after_tomorrow_icon: @weather[:rancagua]["daily"]["data"][2]["icon"],
      aa_tomorrow_max: @weather[:rancagua]["daily"]["data"][3]["temperatureMax"].to_i,
      aa_tomorrow_min: @weather[:rancagua]["daily"]["data"][3]["temperatureMin"].to_i,
      aa_tomorrow_icon: @weather[:rancagua]["daily"]["data"][3]["icon"],
      aaa_tomorrow_max: @weather[:rancagua]["daily"]["data"][4]["temperatureMax"].to_i,
      aaa_tomorrow_min: @weather[:rancagua]["daily"]["data"][4]["temperatureMin"].to_i,
      aaa_tomorrow_icon: @weather[:rancagua]["daily"]["data"][4]["icon"],
    )
    puts "New record saved. Location: #{location.name} at #{Time.now}".green
    location = General::Location.talca
    puts "Saving data information for #{location.name}..."
    General::WeatherInformation.create(
      location_id: location.id,
      date: @today,
      current_temp: @weather[:talca]["currently"]["temperature"],
      condition: @weather[:talca]["currently"]["summary"],
      icon: @weather[:talca]["currently"]["icon"],
      uv_index: @weather[:talca]["currently"]["uvIndex"].to_i,
      max_temp: @weather[:talca]["daily"]["data"][0]["temperatureMax"],
      min_temp: @weather[:talca]["daily"]["data"][0]["temperatureMin"],
      tomorrow_max: @weather[:talca]["daily"]["data"][1]["temperatureMax"].to_i,
      tomorrow_min: @weather[:talca]["daily"]["data"][1]["temperatureMin"].to_i,
      tomorrow_icon: @weather[:talca]["daily"]["data"][1]["icon"],
      after_tomorrow_max: @weather[:talca]["daily"]["data"][2]["temperatureMax"].to_i,
      after_tomorrow_min: @weather[:talca]["daily"]["data"][2]["temperatureMin"].to_i,
      after_tomorrow_icon: @weather[:talca]["daily"]["data"][2]["icon"],
      aa_tomorrow_max: @weather[:talca]["daily"]["data"][3]["temperatureMax"].to_i,
      aa_tomorrow_min: @weather[:talca]["daily"]["data"][3]["temperatureMin"].to_i,
      aa_tomorrow_icon: @weather[:talca]["daily"]["data"][3]["icon"],
      aaa_tomorrow_max: @weather[:talca]["daily"]["data"][4]["temperatureMax"].to_i,
      aaa_tomorrow_min: @weather[:talca]["daily"]["data"][4]["temperatureMin"].to_i,
      aaa_tomorrow_icon: @weather[:talca]["daily"]["data"][4]["icon"],
    )
    puts "New record saved. Location: #{location.name} at #{Time.now}".green
    location = General::Location.concepcion
    puts "Saving data information for #{location.name}..."
    General::WeatherInformation.create(
      location_id: location.id,
      date: @today,
      current_temp: @weather[:concepcion]["currently"]["temperature"],
      condition: @weather[:concepcion]["currently"]["summary"],
      icon: @weather[:concepcion]["currently"]["icon"],
      uv_index: @weather[:concepcion]["currently"]["uvIndex"].to_i,
      max_temp: @weather[:concepcion]["daily"]["data"][0]["temperatureMax"],
      min_temp: @weather[:concepcion]["daily"]["data"][0]["temperatureMin"],
      tomorrow_max: @weather[:concepcion]["daily"]["data"][1]["temperatureMax"].to_i,
      tomorrow_min: @weather[:concepcion]["daily"]["data"][1]["temperatureMin"].to_i,
      tomorrow_icon: @weather[:concepcion]["daily"]["data"][1]["icon"],
      after_tomorrow_max: @weather[:concepcion]["daily"]["data"][2]["temperatureMax"].to_i,
      after_tomorrow_min: @weather[:concepcion]["daily"]["data"][2]["temperatureMin"].to_i,
      after_tomorrow_icon: @weather[:concepcion]["daily"]["data"][2]["icon"],
      aa_tomorrow_max: @weather[:concepcion]["daily"]["data"][3]["temperatureMax"].to_i,
      aa_tomorrow_min: @weather[:concepcion]["daily"]["data"][3]["temperatureMin"].to_i,
      aa_tomorrow_icon: @weather[:concepcion]["daily"]["data"][3]["icon"],
      aaa_tomorrow_max: @weather[:concepcion]["daily"]["data"][4]["temperatureMax"].to_i,
      aaa_tomorrow_min: @weather[:concepcion]["daily"]["data"][4]["temperatureMin"].to_i,
      aaa_tomorrow_icon: @weather[:concepcion]["daily"]["data"][4]["icon"],
    )
    puts "New record saved. Location: #{location.name} at #{Time.now}".green
    location = General::Location.temuco
    puts "Saving data information for #{location.name}..."
    General::WeatherInformation.create(
      location_id: location.id,
      date: @today,
      current_temp: @weather[:temuco]["currently"]["temperature"],
      condition: @weather[:temuco]["currently"]["summary"],
      icon: @weather[:temuco]["currently"]["icon"],
      uv_index: @weather[:temuco]["currently"]["uvIndex"].to_i,
      max_temp: @weather[:temuco]["daily"]["data"][0]["temperatureMax"],
      min_temp: @weather[:temuco]["daily"]["data"][0]["temperatureMin"],
      tomorrow_max: @weather[:temuco]["daily"]["data"][1]["temperatureMax"].to_i,
      tomorrow_min: @weather[:temuco]["daily"]["data"][1]["temperatureMin"].to_i,
      tomorrow_icon: @weather[:temuco]["daily"]["data"][1]["icon"],
      after_tomorrow_max: @weather[:temuco]["daily"]["data"][2]["temperatureMax"].to_i,
      after_tomorrow_min: @weather[:temuco]["daily"]["data"][2]["temperatureMin"].to_i,
      after_tomorrow_icon: @weather[:temuco]["daily"]["data"][2]["icon"],
      aa_tomorrow_max: @weather[:temuco]["daily"]["data"][3]["temperatureMax"].to_i,
      aa_tomorrow_min: @weather[:temuco]["daily"]["data"][3]["temperatureMin"].to_i,
      aa_tomorrow_icon: @weather[:temuco]["daily"]["data"][3]["icon"],
      aaa_tomorrow_max: @weather[:temuco]["daily"]["data"][4]["temperatureMax"].to_i,
      aaa_tomorrow_min: @weather[:temuco]["daily"]["data"][4]["temperatureMin"].to_i,
      aaa_tomorrow_icon: @weather[:temuco]["daily"]["data"][4]["icon"],
    )
    puts "New record saved. Location: #{location.name} at #{Time.now}".green
    location = General::Location.puerto_montt
    puts "Saving data information for #{location.name}..."
    General::WeatherInformation.create(
      location_id: location.id,
      date: @today,
      current_temp: @weather[:puerto_montt]["currently"]["temperature"],
      condition: @weather[:puerto_montt]["currently"]["summary"],
      icon: @weather[:puerto_montt]["currently"]["icon"],
      uv_index: @weather[:puerto_montt]["currently"]["uvIndex"].to_i,
      max_temp: @weather[:puerto_montt]["daily"]["data"][0]["temperatureMax"],
      min_temp: @weather[:puerto_montt]["daily"]["data"][0]["temperatureMin"],
      tomorrow_max: @weather[:puerto_montt]["daily"]["data"][1]["temperatureMax"].to_i,
      tomorrow_min: @weather[:puerto_montt]["daily"]["data"][1]["temperatureMin"].to_i,
      tomorrow_icon: @weather[:puerto_montt]["daily"]["data"][1]["icon"],
      after_tomorrow_max: @weather[:puerto_montt]["daily"]["data"][2]["temperatureMax"].to_i,
      after_tomorrow_min: @weather[:puerto_montt]["daily"]["data"][2]["temperatureMin"].to_i,
      after_tomorrow_icon: @weather[:puerto_montt]["daily"]["data"][2]["icon"],
      aa_tomorrow_max: @weather[:puerto_montt]["daily"]["data"][3]["temperatureMax"].to_i,
      aa_tomorrow_min: @weather[:puerto_montt]["daily"]["data"][3]["temperatureMin"].to_i,
      aa_tomorrow_icon: @weather[:puerto_montt]["daily"]["data"][3]["icon"],
      aaa_tomorrow_max: @weather[:puerto_montt]["daily"]["data"][4]["temperatureMax"].to_i,
      aaa_tomorrow_min: @weather[:puerto_montt]["daily"]["data"][4]["temperatureMin"].to_i,
      aaa_tomorrow_icon: @weather[:puerto_montt]["daily"]["data"][4]["icon"],
    )
    puts "New record saved. Location: #{location.name} at #{Time.now}".green
  end

  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end
end
