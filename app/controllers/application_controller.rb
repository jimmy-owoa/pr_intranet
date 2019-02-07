class ApplicationController < ActionController::Base
  include Pundit
  before_action :set_ip
  protect_from_forgery
  # before_action :authenticate_user!
  before_action :set_locale
  # after_action :track_action

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def set_ip
    @ip = Rails.application.credentials.develop_md # Develop ip
    # @ip = Rails.application.credentials.production # Production ip
  end

  def after_sign_in_path_for(user)
    if current_user.has_role? :super_admin
      admin_root_path
    else
      frontend_welcome_path
    end
  end  

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def set_locale
    I18n.config.available_locales = :es
  end
  
  private
  def user_not_authorized
    flash[:alert] = "Tú no estás autorizado para realizar esta acción."
    redirect_to(request.referrer || admin_root_path)
  end
end
