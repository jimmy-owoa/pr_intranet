require 'uri'
require 'net/http'
module Frontend
  class MenusController < FrontendController
    def menus
      data = []
      menus = General::Menu.all
      menus.each do |menu|
        data << {
          id: menu.id,
          title: menu.title,
          description: menu.description,
          css_class: menu.css_class,
          code: menu.code,
          priority: menu.priority,
          parent_id: menu.parent_id,
          link: menu.link,
          tags: menu.cached_tags,
          companies: menu.cached_categories,
        }
      end
      respond_to do |format|
        format.json { render json: data }
        format.js
      end
    end

    def api_menu
      user_id = 3 # TODO: Cambiar al correcto
      location_id = 2 # TODO: Cambiar al correcto
      menus = General::Menu.all
      user = General::User.find(user_id)
      weather = General::WeatherInformation.current(location_id)
      location = General::Location.find(location_id) 
      santoral = General::Santoral.current
      today = Date.today
      indicator = General::EconomicIndicator
      indicators = indicator.where(date: today)
      data_indicators = []
      if indicator.where(date: today).present?    
        data_indicators << {
          TODAY: l(Date.today, format: '%A %d %B %Y'),
          YESTERDAY: (Date.today-1).strftime("%d/%m"),
          YESTERDAY_1: (Date.today-2).strftime("%d/%m"),
          YESTERDAY_2: (Date.today-3).strftime("%d/%m"),
          MONTH: l(Date.today, format: '%B'),
          MONTH_1: l(Date.today-1.month, format: '%B'),
          MONTH_2: l(Date.today-2.month, format: '%B'),
          MONTH_3: l(Date.today-3.month, format: '%B'),
          DOLAR: indicator.indicator_type(1).last,
          EURO: indicator.indicator_type(2).last,
          UF: indicator.indicator_type(3).last,
          UTM: indicator.indicator_type(4).last,
          IPC: indicator.indicator_type(5).last,
          IPSA: indicator.indicator_type(6).last,
          IPSA_VARIATION: indicator.indicator_type(7).last,
          LATEST_DOLAR: indicator.indicator_type(1),
          LATEST_EURO: indicator.indicator_type(2),
          LATEST_UF: indicator.indicator_type(3),
          LATEST_IPC: indicator.indicator_type(5),
          LATEST_UTM: indicator.indicator_type(4),
          LATEST_IPSA: indicator.indicator_type(6)
        }
      else
        data_indicators << {
          TODAY: l(Date.today, format: '%A %d %B %Y'),
          YESTERDAY: (Date.today-1).strftime("%d/%m"),
          YESTERDAY_1: (Date.today-2).strftime("%d/%m"),
          YESTERDAY_2: (Date.today-3).strftime("%d/%m"),
          MONTH: l(Date.today, format: '%B'),
          MONTH_1: l(Date.today-1.month, format: '%B'),
          MONTH_2: l(Date.today-2.month, format: '%B'),
          MONTH_3: l(Date.today-3.month, format: '%B'),   
          DOLAR: indicator.where(economic_indicator_type_id: 1).last.value,
          EURO: indicator.where(economic_indicator_type_id: 2).last.value,
          UF: indicator.where(economic_indicator_type_id: 3).last.value,
          UTM: indicator.where(economic_indicator_type_id: 4).last.value,
          IPC: indicator.where(economic_indicator_type_id: 5).last.value,
          IPSA: indicator.where(economic_indicator_type_id: 6).last.value,
          IPSA_VARIATION: indicator.where(economic_indicator_type_id: 7).last.value,
          LATEST_DOLAR: indicator.indicator_type(1),
          LATEST_EURO: indicator.indicator_type(2),
          LATEST_UF: indicator.indicator_type(3),
          LATEST_IPC: indicator.indicator_type(5),
          LATEST_UTM: indicator.indicator_type(4),
          LATEST_iPSA: indicator.indicator_type(6)
        }
      end
      if user.legal_number.present?
        exa_menu_url = URI.parse("https://misecurity-qa2.exa.cl/json_menus/show/#{user.legal_number}")
        exa_menu_response = Net::HTTP.get_response exa_menu_url
        exa_menu = JSON.parse(exa_menu_response.body)
      else
        exa_menu = ""
      end
      data = {
        menus: menus,
        user: user,
        weather: weather,
        santoral: santoral[0],
        location_name: location.name,
        exa_menu: exa_menu,
        indicators: data_indicators[0],
        today: today,
      }
      menu_json = render_to_string(partial: 'api_client/menu.html.erb', layout: false, locals: data).to_json
      respond_to do |format|
        format.json { render json: menu_json }
      end
    end
  end
end