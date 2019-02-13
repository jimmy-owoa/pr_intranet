class Frontend::SantoralsController < ApplicationController
  include Rails.application.routes.url_helpers

  def santorals    
    @santorals = General::Santoral.date_santoral
  end
end
