module Frontend
  class BenefitGroupsController < FrontendController
    def index
      benefit_groups = General::BenefitGroup.all.map(&:name)
      respond_to do |format|
        format.html
        format.json { render json: benefit_groups }
        format.js
      end
    end
  end
end