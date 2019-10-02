require 'will_paginate/array'
class Admin::AdminController < ApplicationController
  layout 'admin'
  add_breadcrumb "Inicio", :admin_root_path
  before_action :auth_user

  def auth_user
    redirect_to user_azure_oauth2_omniauth_authorize_path if !current_user
  end

  def after_sign_in_path_for(resource)
    session[:url] || root_path
  end
end
