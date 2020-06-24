require "uri"
require "net/http"

module Api::V1
  class MenusController < ApiController
    include ApplicationHelper
    # skip_before_action :verify_authenticity_token, only: [:get_gospel_menu, :post_gospel_menu]
    skip_before_action :get_user, only: [:get_gospel_menu]

    def request_exa_url
      "https://misecurity-qa3.exa.cl/json_menus/show"
    end

    # Se usa para el menú de caida
    def index
      user_menus = General::Menu.profiled_menus(@request_user)
      main_menus = user_menus.where(title: params[:title])
      if !main_menus.present?
        render json: { message: "Menú no encontrado en la base de datos." }, status: :error
        return
      end
      data = { title: main_menus.first.title, menus: [], menus_dropdown: [] }
      parent_menu = user_menus.find(main_menus.first.parent_id)
      integration_code = main_menus.pluck(:integration_code).reject(&:blank?).first
      menus = user_menus.where(parent_id: main_menus.first.id)
      if @request_user.legal_number.present?
        exa_menu = do_request(@request_user)
        menus_filtered = exa_menu.select { |key, value| value["cod"] == integration_code } if exa_menu.present?
        if menus_filtered.present?
          drop_downs = menus_filtered[integration_code]["drop_down"]
          if drop_downs.values.first["drop_down"].present?
            drop_downs.values.each do |dropdown|
              if dropdown["drop_down"].present?
                m = { title: dropdown["nombre"], submenus: [] }
                dropdown["drop_down"].values.each do |menu|
                  m[:submenus] << { title: menu["nombre"], link: "https://misecurity-qa3.exa.cl" + menu["link"] }
                end
                data[:menus_dropdown] << m
              else
                m = { title: dropdown["nombre"], submenus: [] }
                drop_downs.values.first["drop_down"].values.each do |menu|
                  m[:submenus] << { title: menu["nombre"], link: "https://misecurity-qa3.exa.cl" + menu["link"] }
                end
                data[:menus_dropdown] << m
              end
            end
          else
            drop_downs.values.each do |menu|
              data[:menus] << { title: menu["nombre"], link: "https://misecurity-qa3.exa.cl" + menu["link"] }
            end
          end
        end
        # data[:menus] << exa_menu
      end
      menus.each do |menu|
        data[:menus] << {
          title: menu.title,
          link: menu.link,
        }
      end

      respond_to do |format|
        format.json { render json: data }
        format.js
      end
    end

    def get_merged_menus(title, user_menus, exa_menu)
      menu = user_menus.where(title: title).first
      data = { title: menu.title, submenus: [] }
      integration_code = menu.integration_code
      menus_filtered = exa_menu.select { |key, value| value["cod"] == integration_code } if exa_menu.present?
      if menus_filtered.present? && integration_code.present? && menus_filtered[integration_code]["drop_down"].present?
        drop_downs = menus_filtered[integration_code]["drop_down"]
        if drop_downs.values.first["drop_down"].present?
          drop_downs.values.each do |dropdown|
            if dropdown["drop_down"].present?
              m = { title: dropdown["nombre"], submenus: [] }
              dropdown["drop_down"].values.each do |menu|
                m[:submenus] << { title: menu["nombre"], link: "https://misecurity-qa3.exa.cl" + menu["link"] }
              end
              data[:submenus] << m
            else
              m = { title: dropdown["nombre"], submenus: [] }
              drop_downs.values.first["drop_down"].values.each do |menu|
                m[:submenus] << { title: menu["nombre"], link: "https://misecurity-qa3.exa.cl" + menu["link"] }
              end
              data[:submenus] << m
            end
          end
        else
          drop_downs.values.each do |menu|
            data[:submenus] << { title: menu["nombre"], link: "https://misecurity-qa3.exa.cl" + menu["link"] }
          end
        end
      end
      # data[:submenus] << exa_menu
      menus = user_menus.where(parent_id: menu.id)
      menus.each do |menu|
        data[:submenus] << {
          title: menu.title,
          link: menu.link,
        }
      end
      data
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

    def api_menu_mobile
      main_menus = @request_user.has_role?(:super_admin) ? General::Menu.where(parent_id: nil, code: nil) : General::Menu.where(parent_id: nil, code: nil).where.not(title: "Gestionar")
      menus = General::Menu.all.uniq.reject(&:blank?) - main_menus
      user_menus = General::Menu.profiled_menus(@request_user)
      data = []
      # if @request_user.legal_number.present?
      #   exa_menu = do_request(@request_user)
      # end

      all_menus = user_menus.where(id: menus)
      menu_hash = {}

      main_menus.each do |main_menu|
        menu_hash[main_menu.id] = { title: main_menu.title, menus: [] }
        x = all_menus.where(parent_id: main_menu.id)
        if x.present?
          x.each do |menu|
            # menu_hash[main_menu.id][:menus] << get_merged_menus(menu.title, user_menus, exa_menu)
            menu_hash[main_menu.id][:menus] << get_merged_menus(menu.title, user_menus, "")
          end
          data << menu_hash[main_menu.id]
        end
      end
      respond_to do |format|
        format.json { render json: data }
        format.js
      end
    end

    def api_menu_vue
      base_api_url = root_url
      base_search_url = get_frontend_url + "/resultados/"
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
      santoral = General::Santoral.current_santoral
      santoral_next = General::Santoral.get_santoral_next
      today = Date.today
      indicator = General::EconomicIndicator
      indicators = indicator.where(date: today)
      data_indicators = []
      data_indicators = get_data_indicators(indicator, today)
      if user.legal_number.present?
        benefits = user.benefit_group.present? ? user.benefit_group.benefits : nil
        exa_menu = do_request(user)
        @main_menus = user.has_role?(:super_admin) ? General::Menu.where(parent_id: nil, code: nil) : General::Menu.where(parent_id: nil, code: nil).where.not(title: "Gestionar") #TODO: ESTO ESTÁ HORRIBLE.
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
          content: gospel.content.chomp("Para recibir cada mañana el Evangelio por correo electrónico, registrarse: <a href=\"http://evangeliodeldia.org\" target=\"_blank\">evangeliodeldia.org</a>"),
          santoral_name: General::Santoral.get_santoral(gospel.date).name[0...10],
          santoral_name_tooltip: General::Santoral.get_santoral(gospel.date).name,
          santoral_next: General::Santoral.get_santoral(gospel.date + 1.days).name,
        }
      else
        data = Religion::Gospel.last
      end

      respond_to do |format|
        format.json { render json: data }
      end
    end

    private

    def do_request(user)
      uri = URI.parse(request_exa_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = 3
      http.open_timeout = 3
      http.use_ssl = true

      encrypted_user = InternalAuth.encrypt(user.legal_number + user.legal_number_verification)
      begin
        response = http.post(uri.path, "user_code_crypted_base64=#{encrypted_user}")
        if response.is_a?(Net::HTTPSuccess) && !"\n".in?(response.body)
          menu = Menu::Exa.where(user_id: user.id).last
          if menu.present?
            menu.update(body: response.body)
          else
            Menu::Exa.create(body: response.body, user_id: user.id)
          end
        end
        exa_menu = JSON.parse(user.menu_exa.body)
        exa_menu
      rescue => exception
        ""
      end
    end
  end
end