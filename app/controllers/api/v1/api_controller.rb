require "resolv-replace"

class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  # before_action :get_user, except: [:azure_auth, :current_user_azure, :referrer_update]
  before_action :get_user
  include JsonWebToken
  include Frontend::FrontendHelper

  def index
  end

  # def current_user_azure
  #   referrer = params[:referrer].gsub("#/", "/").insert(1, "#/") || "/"
  #   user = get_current_user_jwt
  #   respond_to do |format|
  #     if user.present?
  #       format.json { render json: { message: "OK", token: http_auth_header, cod: params[:cod], referrer: user.referrer } }
  #     else
  #       format.json { render json: { error: "No hay user" } }
  #     end
  #   end
  # end

  # def referrer_update(token, referrer)
  #   decoded = JsonWebToken.decode(token)
  #   if decoded.present? && referrer != "/"
  #     General::User.find(decoded[:user_id]).update(referrer: "/##{referrer}")
  #   end
  #   referrer
  # end

  # def azure_auth
  #   session[:referrer] = params[:referrer] || admin_root_path
  #   redirect_to user_azure_oauth2_omniauth_authorize_path
  # end

  private

  # def get_current_user_jwt
  #   if params[:cod].present? && params[:url].present? && !params[:view_as].present? || params[:view_as] == "null"
  #     referrer_update(params[:cod], params[:url])
  #   end
  #   @request_user ||= General::User.find(decoded_auth_token[:user_id]) if decoded_auth_token
  #   @request_user || nil
  # end

  # def decoded_auth_token
  #   @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  # end

  # def http_auth_header
  #   if request.headers["Authorization"].present?
  #     return request.headers["Authorization"].split(" ").last
  #   end
  #   nil
  # end

  # def is_exa(referrer)
  #   exa_urls = ["https://misecurity-qa3.exa.cl/",
  #               "https://misecurity-qa2.exa.cl/",
  #               "https://misecurity-qa.exa.cl/",
  #               "https://misecurity.exa.cl/"]
  #   exa_urls.each do |url|
  #     return true if url.in?(referrer)
  #   end
  #   false
  # end

  # def get_user
  #   # Si es que no viene el view_as y si viene el params que se llama url, y el user_id dentro de token
  #   if !is_exa(request.referrer)
  #     @request_user = get_current_user_jwt if http_auth_header.present?
  #     if @request_user.present? && @request_user.has_role?(:super_admin) && params[:view_as].present? && params[:view_as] != "null"
  #       @request_user = General::User.get_user_by_ln(params[:view_as])
  #     end
  #     if !@request_user.present?
  #       redirect_to user_azure_oauth2_omniauth_authorize_path
  #     end
  #   end
  # end

  def get_user
    @request_user = General::User.all.sample(1).first
    # @request_user = General::User.find(11)
  end
end
