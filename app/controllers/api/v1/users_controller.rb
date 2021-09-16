module Api::V1
  class UsersController < ApiController
    include Rails.application.routes.url_helpers
    include ApplicationHelper
    skip_before_action :verify_authenticity_token, only: [:upload, :sign_in]
    skip_before_action :set_current_user_from_header, only: [:sign_in]

    def sign_in
      user_code = params[:user][:user_code]
      return handle_400 if user_code.blank?
      
      id_exa = InternalAuth.decrypt(user_code) rescue ""
      user = General::User.find_by(id_exa: id_exa)
      return handle_400 if user.blank?
      
      render json: { success: true, token: user.as_json_with_jwt[:token] }
    end

    def current_user_vue
      data = ActiveModelSerializers::SerializableResource.new(request_user, serializer: UserSerializer)
      render json: { user: data }, status: :ok
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
