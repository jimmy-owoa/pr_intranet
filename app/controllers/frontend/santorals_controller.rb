module Frontend
  class SantoralsController < FrontendController
  include Rails.application.routes.url_helpers

  def santorals    
    @santorals = General::Santoral.date_santoral
    respond_to do |format|
      format.json { render json: @santorals }
      format.js
    end    
  end
end
end