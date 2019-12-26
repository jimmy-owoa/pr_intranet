require "uri"
require "net/http"

module Frontend
  class MenusController < FrontendController
    # protect_from_forgery except: :api_menu
    skip_before_action :verify_authenticity_token, only: [:get_gospel_menu, :post_gospel_menu]
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

    def get_rails_env
      if Rails.env.dev?
        "http://localhost:8080/#/resultados/"
      else
        "https://miintranet.exaconsultores.cl/#/resultados/"
      end
    end

    def get_request_referer
      if request.referer == "https://misecurity-qa3.exa.cl/"
        "https://miintranet.exaconsultores.cl/"
      elsif request.referer == "https://miintranet.exaconsultores.cl/"
        request.referer
      elsif request.referer == "http://intranet-security-qa-v1.s3-website.us-east-2.amazonaws.com/"
        request.referer
      elsif request.referer == "http://localhost:8080/"
        request.referer
      else
        "https://miintranet.exaconsultores.cl/"
      end
    end

    def get_data_indicators(indicator, today)
      data_indicators = []

      if indicator.where(date: today).present?
        data_indicators << {
          DOLAR: indicator.indicator_type(1).last(2),
          EURO: indicator.indicator_type(2).last(2),
          UF: indicator.indicator_type(3).last(2),
          UTM: indicator.indicator_type(4).last(2),
          IPC: indicator.indicator_type(5).last(2),
          IPSA: indicator.indicator_type(6).last(2),
          IPSA_VARIATION: indicator.indicator_type(7).last(2),
          LATEST_DOLAR: indicator.indicator_type(1),
          LATEST_EURO: indicator.indicator_type(2),
          LATEST_UF: indicator.indicator_type(3),
          LATEST_IPC: indicator.indicator_type(5),
          LATEST_UTM: indicator.indicator_type(4),
          LATEST_IPSA: indicator.indicator_type(6),
        }
      else
        data_indicators << {
          DOLAR: indicator.where(economic_indicator_type_id: 1).pluck(:value).last(2),
          EURO: indicator.where(economic_indicator_type_id: 2).pluck(:value).last(2),
          UF: indicator.where(economic_indicator_type_id: 3).pluck(:value).last(2),
          UTM: indicator.where(economic_indicator_type_id: 4).pluck(:value).last(2),
          IPC: indicator.where(economic_indicator_type_id: 5).pluck(:value).last(2),
          IPSA: indicator.where(economic_indicator_type_id: 6).pluck(:value).last(2),
          IPSA_VARIATION: indicator.where(economic_indicator_type_id: 7).pluck(:value).last(2),
          LATEST_DOLAR: indicator.indicator_type(1),
          LATEST_EURO: indicator.indicator_type(2),
          LATEST_UF: indicator.indicator_type(3),
          LATEST_IPC: indicator.indicator_type(5),
          LATEST_UTM: indicator.indicator_type(4),
          LATEST_iPSA: indicator.indicator_type(6),
        }
      end

      data_indicators
    end

    def api_menu_vue
      base_api_url = root_url
      base_search_url = get_rails_env
      user = params[:user_code_crypted_base64].present? ? General::User.get_user_by_ln(InternalAuth.decrypt(params[:user_code_crypted_base64])) : @request_user
      location_id = user.location_id || 2
      menus = []
      General::Menu.all.each do |menu|
        if menu.profile_id.present?
          menus << menu if menu.profile_id.in?(user.profile_ids)
        else
          menus << menu
        end
      end
      host = get_request_referer
      weather = General::WeatherInformation.current(location_id).present? ? General::WeatherInformation.current(location_id) : General::WeatherInformation.last(location_id)
      uv_index = weather.last.get_uv
      location = General::Location.find(location_id)
      santoral = General::Santoral.current
      santoral_next = General::Santoral.next
      today = Date.today
      indicator = General::EconomicIndicator
      indicators = indicator.where(date: today)
      data_indicators = []
      data_indicators = get_data_indicators(indicator, today)
      if user.legal_number.present?
        uri = URI.parse("https://misecurity-qa.exa.cl/json_menus/show")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        encrypted_user = InternalAuth.encrypt(user.legal_number + user.legal_number_verification)
        response = http.post(uri.path, "user_code_crypted_base64=#{encrypted_user}")
        exa_menu = JSON.parse(response.body) if response.code.to_i < 400
        benefits = user.benefit_group.present? ? user.benefit_group.benefits : nil

        @main_menus = General::Menu.where(parent_id: nil, code: nil) #TODO: ESTO ESTÁ HORRIBLE.
        if exa_menu.present? && exa_menu["manage"].present?
          @main_menus << General::Menu.where(code: "manage").first if General::Menu.where(code: "manage").present?
        end
      else
        exa_menu = ""
      end

      data = {
        menus: menus,
        host: host,
        user: user,
        user_profile_ids: user.profile_ids,
        user_image: user.image.attached? ? url_for(user.image.variant(combine_options: { resize: "x42", gravity: "Center" })) : "",
        weather: weather,
        uv_index: uv_index,
        santoral: santoral.last,
        santoral_next: santoral_next.last,
        location_name: location.name,
        exa_menu: exa_menu,
        gospel: Religion::Gospel.gospel_today,
        indicators: data_indicators[0],
        today: today,
        beauty_date: l(today, format: "%d de %B de %Y"),
        base_api_url: base_api_url,
        base_search_url: base_search_url,
        benefits: benefits,
      }
      menu_json = render_to_string(partial: "api_client/menu.html.erb", layout: false, locals: data).to_json
      respond_to do |format|
        format.json { render json: menu_json.encode("UTF-8") }
      end
    end

    def get_gospel_menu
      day = params[:days].to_i if params[:days].present?
      if day.present? 
        gospel = Religion::Gospel.get_gospel(day)
        selected_today = Date.today == gospel.date ? "Hoy, " : ""
        selected_tomorrow = Date.today == gospel.date ? "Mañana, " : ""
        data = {
          id: gospel.id,
          select_day: l(gospel.date, format: "%A"),
          date_today: selected_today + l(gospel.date, format: "%d de %B").downcase,
          date_tomorrow: selected_tomorrow + l(gospel.date + 1.days, format: "%d de %B").downcase,
          title: gospel.title,
          content: gospel.content,
          santoral_name: General::Santoral.get_santoral(gospel.date).name[0...10],
          santoral_next: General::Santoral.where(santoral_day: (gospel.date + 1.days).strftime('%m-%d')).last.name[0...10]
        }
      else
        data = Religion::Gospel.last
      end

      respond_to do |format|
        format.json { render json: data }
      end
    end
  end
end
