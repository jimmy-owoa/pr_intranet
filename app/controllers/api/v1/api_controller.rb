require "resolv-replace"

class Api::V1::ApiController < ApplicationController
  # skip_before_action :verify_authenticity_token

  include JsonWebToken
  include Frontend::FrontendHelper

  before_action :set_current_user_from_header

  def set_current_user_from_header
    auth_header = request.headers["Authorization"]
    token = auth_header.split(" ").last rescue nil
    results = JsonWebToken.decode(token)
    id_exa = results["id_exa"] rescue nil

    @request_user = General::User.find_by(id_exa: id_exa)
    handle_401 if !@request_user.present?
  end

  def request_user
    return handle_401 if @request_user.blank?
    @request_user
  end

  def index
  end

  def meta_attributes(collection)
    {
      size: collection.size,
      current_page: collection.current_page,
      next_page: collection.next_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end

  def record_not_found
    render json: { msg: "Error" }, status: :not_found
  end

  def handle_400
    render json: { success: false, message: "Bad request" }, status: :bad_request and return
  end

  def handle_401
    render json: { success: false, message: "Not logged in or invalid auth token" }, status: :unauthorized and return
  end
end
