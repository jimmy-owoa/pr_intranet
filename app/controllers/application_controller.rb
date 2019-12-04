class ApplicationController < ActionController::Base
  include Pundit
  before_action :set_ip
  # protect_from_forgery
  before_action :set_locale

  def index
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def set_ip
    @ip = Rails.env.production? ? Rails.application.credentials.production : Rails.application.credentials.develop # Develop ip
  end

  def after_sign_in_path_for(resource)
    if request.env.present? && request.env["omniauth.origin"].present?
      user_jwt = JsonWebToken.encode(user_id: current_user.id) if current_user
      request.env["omniauth.origin"] + "&r=#{current_user.referrer}" # Agregar referrer guardado en session[:referrer]
    else
      admin_root_path
    end
  end

  def set_locale
    I18n.config.available_locales = :es
  end

  private

  def user_not_authorized
    flash[:alert] = "No estás autorizado para realizar esta acción."
    redirect_to(request.referrer || admin_root_path)
  end
end
