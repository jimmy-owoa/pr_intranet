class Frontend::FrontendController < ApplicationController
  before_action :get_user, except: [:azure_auth, :current_user_azure]
  include JsonWebToken

  def index
  end

  def indicators
    data = []
    today = Date.today.strftime("%d/%m/%Y")
    indicator = General::EconomicIndicator
    indicators = indicator.where(date: today)
    if indicator.where(date: today).present?
      data << {
        TODAY: l(Date.today, format: "%A %d %B %Y"),
        YESTERDAY: (Date.today - 1).strftime("%d/%m"),
        YESTERDAY_1: (Date.today - 2).strftime("%d/%m"),
        YESTERDAY_2: (Date.today - 3).strftime("%d/%m"),
        MONTH: l(Date.today, format: "%B"),
        MONTH_1: l(Date.today - 1.month, format: "%B"),
        MONTH_2: l(Date.today - 2.month, format: "%B"),
        MONTH_3: l(Date.today - 3.month, format: "%B"),
        DOLAR: indicator.indicator_type(1).last,
        EURO: indicator.indicator_type(2).last,
        UF: indicator.indicator_type(3).last,
        UTM: indicator.indicator_type(4).last,
        IPC: indicator.indicator_type(5).last,
        IPSA: indicator.indicator_type(6).last,
        IPSA_VARIATION: indicator.indicator_type(7).last,
        LATEST_DOLAR: indicator.indicator_type(1),
        LATEST_EURO: indicator.indicator_type(2),
        LATEST_UF: indicator.indicator_type(3),
        LATEST_IPC: indicator.indicator_type(5),
        LATEST_UTM: indicator.indicator_type(4),
        LATEST_IPSA: indicator.indicator_type(6),
      }
    else
      data << {
        TODAY: l(Date.today, format: "%A %d %B %Y"),
        YESTERDAY: (Date.today - 1).strftime("%d/%m"),
        YESTERDAY_1: (Date.today - 2).strftime("%d/%m"),
        YESTERDAY_2: (Date.today - 3).strftime("%d/%m"),
        MONTH: l(Date.today, format: "%B"),
        MONTH_1: l(Date.today - 1.month, format: "%B"),
        MONTH_2: l(Date.today - 2.month, format: "%B"),
        MONTH_3: l(Date.today - 3.month, format: "%B"),
        DOLAR: indicator.where(economic_indicator_type_id: 1).last.value,
        EURO: indicator.where(economic_indicator_type_id: 2).last.value,
        UF: indicator.where(economic_indicator_type_id: 3).last.value,
        UTM: indicator.where(economic_indicator_type_id: 4).last.value,
        IPC: indicator.where(economic_indicator_type_id: 5).last.value,
        IPSA: indicator.where(economic_indicator_type_id: 6).last.value,
        IPSA_VARIATION: indicator.where(economic_indicator_type_id: 7).last.value,
        LATEST_DOLAR: indicator.indicator_type(1),
        LATEST_EURO: indicator.indicator_type(2),
        LATEST_UF: indicator.indicator_type(3),
        LATEST_IPC: indicator.indicator_type(5),
        LATEST_UTM: indicator.indicator_type(4),
        LATEST_iPSA: indicator.indicator_type(6),
      }
    end
    respond_to do |format|
      format.json { render json: data }
      format.js
    end
  end

  def current_user_azure
    referrer = params[:referrer].gsub("#/", "/").insert(1, "#/") || "/"
    user = get_current_user_jwt
    respond_to do |format|
      if user.present?
        user.update(referrer: referrer)
        format.json { render json: { message: "OK", token: http_auth_header, referrer: referrer } }
      else
        format.json { render json: { error: "No hay user" } }
      end
    end
  end

  def azure_auth
    session[:referrer] = params[:referrer] || admin_root_path
    redirect_to user_azure_oauth2_omniauth_authorize_path
  end

  private

  def get_current_user_jwt
    @request_user ||= General::User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    @request_user || nil
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if request.headers["Authorization"].present?
      return request.headers["Authorization"].split(" ").last
    end
    nil
  end

  def get_user
    @request_user = get_current_user_jwt if http_auth_header.present?
    if params[:view_as].present? && params[:view_as] != "null"
      @request_user = General::User.get_user_by_ln(params[:view_as])
    end
  end
end
