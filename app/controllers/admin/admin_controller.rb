require 'will_paginate/array'
class Admin::AdminController < ApplicationController
  # protect_from_forgery with: :exception
  # before_action :authenticate_user!
  layout 'admin'
  add_breadcrumb "Inicio", :admin_root_path
  before_action :auth_user

  def auth_user
    redirect_to user_azure_oauth2_omniauth_authorize_path if !current_user
  end

end