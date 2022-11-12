module Api::V1
  class SocietiesController < ApiController
    include Rails.application.routes.url_helpers
    include ApplicationHelper
  

    def societies
      if params[:user_id] == "undefined"
        ''
      else
        societies = General::Society.where(country: General::User.find(params[:user_id]).country.name)   
      end
      render json: societies , status: :ok
    end
  end
end
  