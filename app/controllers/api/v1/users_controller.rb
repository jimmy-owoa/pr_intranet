module Api::V1
  class UsersController < ApiController
    include Rails.application.routes.url_helpers
    include ApplicationHelper
    skip_before_action :verify_authenticity_token, only: [:upload, :sign_in]
    skip_before_action :set_current_user_from_header, only: [:sign_in]

    def nickname(name)
      name.match(/^([jJ]os.|[jJ]uan|[mM]ar.a) /).present? ? name : name.split.first
    end

    def sign_in
      user_code = params[:user][:user_code]
      return handle_400 if user_code.blank?
      
      id_exa = InternalAuth.decrypt(user_code) rescue ""
      user = General::User.find_by(id_exa: id_exa)
      return handle_400 if user.blank?
      
      render json: { token: user.as_json_with_jwt[:token] }
    end

    def user
      data_user = []
      data_childrens = []
      data_siblings = []
      data_father = []
      id = params[:id].present? ? params[:id] : nil
      @user = General::User.find(id)
      @nickname = nickname(@user.name)
      @location = @user.location.present? ? General::Location.find(@user.location_id).name : "No definido"
      if @user.children.first.present?
        @user.children.where.not(parent_id: nil).each do |children|
          data_childrens << {
            id: children.id,
            name: children.name,
            last_name: children.last_name,
            position: children.position,
            company: children.company.present? ? children.company.name : "Empresa no disponible",
            color: children.get_color,
            image: children.image.attached? ?
              url_for(children.image.variant(resize: "150x150")) : ActionController::Base.helpers.asset_path("default_avatar.png"),
          }
        end
      end
      if @user.siblings.first.present?
        @user.siblings.where.not(parent_id: nil).each do |sibling|
          data_siblings << {
            id: sibling.id,
            name: sibling.name,
            last_name: sibling.last_name,
            position: sibling.position,
            company: sibling.company.present? ? sibling.company.name : "Empresa no disponible",
            color: sibling.get_color,
            image: sibling.image.attached? ?
              url_for(sibling.image.variant(resize: "150x150")) : ActionController::Base.helpers.asset_path("default_avatar.png"),
          }
        end
      end
      if @user.parent.present?
        data_father << {
          id: @user.parent.id,
          name: @user.parent.name,
          last_name: @user.parent.last_name,
          position: @user.parent.position,
          company: @user.parent.company.present? ? @user.parent.company.name : "Empresa no disponible",
          color: @user.get_color,
          image: @user.parent.image.attached? ?
            url_for(@user.parent.image.variant(resize: "150x150")) : ActionController::Base.helpers.asset_path("default_avatar.png"),
        }
      end
      data_user << {
        id: @user.id,
        name: @user.name,
        nickname: @nickname,
        last_name: @user.last_name,
        full_name: get_full_favorite_name(@user),
        email: @user.email,
        annexed: @user.annexed,
        phone: get_phone(@user.annexed),
        position: @user.position,
        company: @user.company.present? ? @user.company.name : "Empresa no disponible",
        birthday: @user.birthday.present? && @user.show_birthday ? @user.birthday.strftime("%d/%m") : "Información oculta",
        is_birthday: @user.is_birthday_today && @user.show_birthday ? true : false,
        address: @user.office.try(:address),
        location: @location,
        full_legal_number: @user.legal_number.present? ? @user.legal_number + @user.legal_number_verification : "sin rut",
        date_entry: @user.date_entry,
        color: @user.get_color,
        image: @user.image.attached? ?
          url_for(@user.image) : ActionController::Base.helpers.asset_path("default_avatar.png"),
        childrens: data_childrens,
        siblings: data_siblings,
        father: data_father,
        benefits: "",
        breadcrumbs: [
          { link: "/", name: "Inicio" },
          { link: "#", name: "Buscar" },
        ],
      }
      respond_to do |format|
        format.json { render json: data_user[0] }
        format.js
      end
    end

    def parents_data
      rut = params[:rut].present? ? params[:rut] : nil
      user = @request_user
      data_childrens = []
      data_siblings = []
      data_father = []
      data = []
      if user.children.first.present?
        user.children.where.not(parent_id: nil).each do |children|
          data_childrens << {
            id: children.id,
            name: children.favorite_name,
            last_name: children.last_name,
            position: children.position,
            company: children.company.present? ? children.company.name.titleize : "Empresa no disponible",
            color: children.get_color,
            image: children.image.attached? ?
              url_for(children.image.variant(resize: "150x150")) : ActionController::Base.helpers.asset_path("default_avatar.png"),
          }
        end
      end
      if user.siblings.first.present?
        user.siblings.where.not(parent_id: nil).each do |sibling|
          data_siblings << {
            id: sibling.id,
            name: sibling.favorite_name,
            last_name: sibling.last_name,
            position: sibling.position,
            company: sibling.company.present? ? sibling.company.name.titleize : "Empresa no disponible",
            color: sibling.get_color,
            image: sibling.image.attached? ?
              url_for(sibling.image.variant(resize: "150x150")) : ActionController::Base.helpers.asset_path("default_avatar.png"),
          }
        end
      end
      if user.parent.present?
        data_father << {
          id: user.parent.id,
          name: user.parent.favorite_name,
          last_name: user.parent.last_name,
          position: user.parent.position,
          company: user.parent.company.present? ? user.parent.company.name.titleize : "Empresa no disponible",
          color: user.parent.get_color,
          image: user.parent.image.attached? ?
            url_for(user.parent.image.variant(resize: "150x150")) : ActionController::Base.helpers.asset_path("default_avatar.png"),
        }
      end
      data << {
        childrens: data_childrens,
        siblings: data_siblings,
        father: data_father,
      }

      render json: { status: "ok", parents_data: data[0] }
    end

    def current_user_vue
      render json: { success: true, user: request_user.as_profile_json }
      # @location = user.location.present? ? General::Location.find(user.location_id).name : "No definido"
      
      # data_user = {
      #   id: user.id,
      #   name: user.name,
      #   favorite_name: user.favorite_name,
      #   last_name: user.last_name,
      #   full_name: get_full_favorite_name(user).titleize,
      #   full_legal_number: user.legal_number.present? ? user.legal_number + user.legal_number_verification : "sin rut",
      #   role: user.roles.pluck(:name),
      #   company: user.company.present? ? user.company.name : "Empresa no disponible",
      #   is_birthday: user.is_birthday_today,
      #   position: user.position,
      #   date_entry: user.date_entry,
      #   image: user.image.attached? ?
      #     url_for(user.image) : ActionController::Base.helpers.asset_path("default_avatar.png"),
      #   email: user.email,
      #   annexed: user.annexed,
      #   phone: get_phone(user.annexed),
      #   address: user.office.try(:address),
      #   location: @location,
      # }

      # render json: { status: "ok", user: data_user }, status: :ok
    end

    def autocomplete_user
      search = params[:user] #acá va la variable del search
      data = []
      # donde se busca, por si tenemos que agregar más que nombre y apellidos
      variables = [
        "name",
        "last_name",
        "last_name2",
        "CONCAT(name,' ',last_name)",
        "CONCAT(name,' ',last_name,' ',last_name2)",
        "CONCAT(last_name,' ',last_name2)",
      ]
      queries = []

      variables.each do |var|
        queries << "#{var} LIKE '%#{search}%'"
      end

      query_where = queries.join(" OR ")
      results = General::User.where(query_where)

      results.each do |result|
        data << { value: result.id,
                 text: result.name + " " + result.last_name }
      end

      respond_to do |format|
        format.json { render json: data }
        format.js
      end
    end

    def set_user
      token = params[:token]
      # START DECRYPT AND VALIDATION
      result = General::User.decrypt(token)
      # END DECRYPT
      cookies.encrypted[:sso_unt] = {
        value: result,
        expires: 1.hour,
      }
      render json: { data: cookies.encrypted[:sso_unt] }, callback: "*"
    end

    def upload
      image = params[:file_img]
      @request_user.new_image.attach(image)

      render json: { status: "ok" }, status: :ok
    end
  end
end
