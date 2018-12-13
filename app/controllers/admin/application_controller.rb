require 'will_paginate/array'
class Admin::ApplicationController < ApplicationController
  # layout 'prueba/header'
  layout 'admin'
  add_breadcrumb "Inicio", :admin_root_path
end
