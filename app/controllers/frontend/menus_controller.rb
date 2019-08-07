require 'uri'
require 'net/http'
module Frontend
  class MenusController < FrontendController
    protect_from_forgery except: :api_menu
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

    def api_menu_vue
      base_api_url = root_url
      base_search_url = if Rails.env.dev?
        "http://localhost:8080/#/resultados/"
      else
        "https://misecurity.elmejorlugarparatrabajar.cl/#/resultados/"
      end
      rut= params[:user_id]
      user = General::User.find_by_legal_number(rut[0...-1])      
      location_id = params[:location_id] || 2 # TODO: Cambiar al correcto
      menus = General::Menu.all
      weather = General::WeatherInformation.current(location_id)
      location = General::Location.find(location_id) 
      santoral = General::Santoral.current
      santoral_next = General::Santoral.next
      today = Date.today
      indicator = General::EconomicIndicator
      indicators = indicator.where(date: today)
      data_indicators = []
      if indicator.where(date: today).present?
        data_indicators << {
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
        benefits = user.benefit_group.present? ? user.benefit_group.benefits : nil
        exa_menu_url = URI.parse("https://misecurity-qa2.exa.cl/json_menus/show/#{user.legal_number}#{user.legal_number_verification}")
        exa_menu_response = Net::HTTP.get_response exa_menu_url
        exa_menu = JSON.parse(exa_menu_response.body)
      else
        exa_menu = ""
      end
      data = {
        menus: menus,
        user: user,
        user_image: url_for(user.image.variant(combine_options: {resize: 'x42', gravity: 'Center'})),
        weather: weather.present? ? weather : General::WeatherInformation.last(location_id),
        santoral: santoral.last,
        santoral_next: santoral_next.last,
        location_name: location.name,
        exa_menu: exa_menu,
        gospel: Religion::Gospel.where(date: Date.today).present? ? Religion::Gospel.where(date: Date.today).last : Religion::Gospel.last,
        indicators: data_indicators[0],
        today: today,
        beauty_date: l(today, format: "%d de %B, %Y"),
        base_api_url: base_api_url,
        base_search_url: base_search_url,
        benefits: benefits
      }
      menu_json = render_to_string(partial: 'api_client/menu.html.erb', layout: false, locals: data).to_json
      respond_to do |format|
        format.json { render json: menu_json.encode("UTF-8") }
      end
    end

    def api_menu
      base_api_url = root_url
      base_search_url = if Rails.env.dev?
        "http://localhost:8080/#/resultados/"
      else
        "https://misecurity.elmejorlugarparatrabajar.cl/#/resultados/"
      end
      rut= params[:user_id]
      user = General::User.find_by_legal_number(rut[0...-1])      
      location_id = params[:location_id] || 2 # TODO: Cambiar al correcto
      menus = General::Menu.all
      weather = General::WeatherInformation.current(location_id)
      location = General::Location.find(location_id) 
      santoral = General::Santoral.current
      today = Date.today
      indicator = General::EconomicIndicator
      indicators = indicator.where(date: today)
      data_indicators = []
      if indicator.where(date: today).present?
        data_indicators << {
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
        benefits = user.benefit_group.present? ? user.benefit_group.benefits : nil
        exa_menu_url = URI.parse("https://misecurity-qa2.exa.cl/json_menus/show/#{user.legal_number}#{user.legal_number_verification}")
        exa_menu_response = Net::HTTP.get_response exa_menu_url
        exa_menu = JSON.parse(exa_menu_response.body)
      else
        exa_menu = ""
      end
      data = {
        menus: menus,
        user: user,
        user_image: url_for(user.image.variant(combine_options: {resize: 'x42', gravity: 'Center'})),
        weather: weather.present? ? weather : General::WeatherInformation.last(location_id),
        santoral: santoral[0],
        location_name: location.name,
        exa_menu: exa_menu,
        gospel: Religion::Gospel.where(date: Date.today).first,
        indicators: data_indicators[0],
        today: today,
        base_api_url: base_api_url,
        base_search_url: base_search_url,
        benefits: benefits
      }
      menu_json = {
        menu: render_to_string(partial: 'api_client/menu.html.erb', layout: false, locals: data).encode("UTF-8")
      }
      respond_to do |format|
        format.json { render json: menu_json, callback: 'api_menu' }
      end
    end
  end
end