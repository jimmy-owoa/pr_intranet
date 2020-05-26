module Api::V1
  class SantoralsController < ApiController
    include Rails.application.routes.url_helpers

    def santorals
      @santorals = General::Santoral.current
      respond_to do |format|
        format.json { render json: @santorals }
        format.js
      end
    end
  end
end
