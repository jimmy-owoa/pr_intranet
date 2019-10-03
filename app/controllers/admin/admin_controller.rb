require 'will_paginate/array'
class Admin::AdminController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  layout 'admin'
  add_breadcrumb "Inicio", :admin_root_path
end