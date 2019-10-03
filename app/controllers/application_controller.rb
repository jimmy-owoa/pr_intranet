class ApplicationController < ActionController::Base

  include Pundit
  before_action :set_ip
  protect_from_forgery
  before_action :set_locale
  before_action :auth_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def set_ip
    @ip = Rails.env.production? ? Rails.application.credentials.production : Rails.application.credentials.develop # Develop ip
  end

  def auth_user
    redirect_to user_azure_oauth2_omniauth_authorize_path if !current_user
  end

  def after_sign_in_path_for(resource)
    session[:url] || root_path
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
