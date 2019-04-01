require 'will_paginate/array'
class Admin::AdminController < ApplicationController
  layout 'admin'
  add_breadcrumb "Inicio", :admin_root_path
  before_action :authenticate_user!
end