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
  end
end
