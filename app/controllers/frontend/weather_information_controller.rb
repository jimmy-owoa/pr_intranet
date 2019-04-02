module Frontend
  class WeatherInformationController < FrontendController
  def weather
    # @weather = General::WeatherInformation.weather_cached
    @weather = General::WeatherInformation.last(10)
    @today =  Date.today.strftime("%d/%m/%Y")
    @tomorrow = l(Date.today + 1, format: '%A')
    @tomorrow_1 = l(Date.today + 2, format: '%A')
    @tomorrow_2 = l(Date.today + 3, format: '%A')
    @tomorrow_3 = l(Date.today + 4, format: '%A')  
    city = 
    data = []
    @weather.each do |w|
      data << {
        id: w.id,
        location_id: w.location_id,
        date: w.date,
        max_temp: w.max_temp,
        min_temp: w.min_temp,
        current_temp: w.current_temp,
        condition: w.condition,
        icon: w.icon,
        created_at: w.created_at,
        updated_at: w.updated_at,
        tomorrow_icon: w.tomorrow_icon,
        tomorrow_max: w.tomorrow_max,
        tomorrow_min: w.tomorrow_min,
        after_tomorrow_icon: w.after_tomorrow_icon,
        after_tomorrow_max: w.after_tomorrow_max,
        after_tomorrow_min: w.after_tomorrow_min,
        aa_tomorrow_icon: w.aa_tomorrow_icon,
        aa_tomorrow_max: w.aa_tomorrow_max,
        aa_tomorrow_min: w.aa_tomorrow_min,
        aaa_tomorrow_icon: w.aaa_tomorrow_icon,
        aaa_tomorrow_max: w.aaa_tomorrow_max,
        aaa_tomorrow_min: w.aaa_tomorrow_min,
        today:  @today,
        tomorrow: @tomorrow,
        tomorrow_1: @tomorrow_1,
        tomorrow_2: @tomorrow_2,
        tomorrow_3: @tomorrow_3
      }
    end
    
    respond_to do |format|
      format.json { render json: data }
      format.js
    end
    end
  end
end