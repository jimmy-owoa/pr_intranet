module Api::V1
  class SocietiesController < ApiController
    include Rails.application.routes.url_helpers
    include ApplicationHelper
  

    def societies
      society = General::Society.all
      render json: society , status: :ok
    end
  end
end
  