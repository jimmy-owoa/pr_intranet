require "uri"
require "net/http"

module Frontend
  class MenusController < FrontendController
    # protect_from_forgery except: :api_menu
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
        "https://misecurity.elmejorlugarparatrabajar.cl/#/resultados/"
      end
    end

    def get_request_referer
      if request.referer == "https://misecurity-qa3.exa.cl/"
        "https://misecurity.elmejorlugarparatrabajar.cl/"
      elsif request.referer == "https://misecurity.elmejorlugarparatrabajar.cl/"
        request.referer
      elsif request.referer == "http://intranet-security-qa-v1.s3-website.us-east-2.amazonaws.com/"
        request.referer
      else
        "http://localhost:8080/"
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
      Rails.logger.info "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
      Rails.logger.info "%%%%%%ln_user%%%%%#{params[:ln_user]}%%%%%%%%%%%%%%%%%"
      user = params[:ln_user].present? ? General::User.get_user_by_ln(params[:ln_user]) : @request_user
      Rails.logger.info "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
      Rails.logger.info "%%%%%%%user%%%%%%%%#{user}%%%%%%%%%%%%%%%%%%%%%%%%"
      location_id = @request_user.location_id || 2
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
        benefits = user.benefit_group.present? ? user.benefit_group.benefits : nil
        exa_menu_url = URI.parse("https://misecurity-qa2.exa.cl/json_menus/show/#{user.legal_number}#{user.legal_number_verification}")
        exa_menu_response = Net::HTTP.get_response exa_menu_url
        exa_menu = JSON.parse(exa_menu_response.body)
        @main_menus = General::Menu.where(parent_id: nil, code: nil) #TODO: ESTO ESTÁ HORRIBLE.
        if exa_menu["manage"].present?
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
        gospel: Religion::Gospel.where(date: Date.today).present? ? Religion::Gospel.where(date: Date.today).last : Religion::Gospel.last,
        indicators: data_indicators[0],
        today: today,
        beauty_date: l(today, format: "%d de %B, %Y"),
        base_api_url: base_api_url,
        base_search_url: base_search_url,
        benefits: benefits,
      }
      menu_json = render_to_string(partial: "api_client/menu.html.erb", layout: false, locals: data).to_json
      respond_to do |format|
        format.json { render json: menu_json.encode("UTF-8") }
      end
    end
  end
end
