module Api::V1
  class SantoralsController < ApiController
    include Rails.application.routes.url_helpers

    def santorals
      santoral = General::Santoral.as_json_with_today
      respond_to do |format|
        format.json { render json: santoral }
        format.js
      end
    end
  end
end