module Frontend
  class BenefitsController < FrontendController
    after_action :set_tracking, only: [:index, :show]

    def index
      benefits = General::Benefit.all
      data = []
      benefits.each do |benefit|
        @image = benefit.image.present? ? url_for(benefit.image.attachment) : root_url + "/assets/
        news.jpg"
        data << {
          id: benefit.id,
          title: benefit.title,
          url: root_url + "admin/benefit_groups/" + "#{benefit.id}" + "/edit",
          content: benefit.content,
          image: @image,
          link: benefit.url,
        }
      end
      respond_to do |format|
        format.json { render json: data }
        format.js
      end
    end

    def benefit
      data = []
      id = params[:id].present? ? params[:id] : nil
      benefit = General::Benefit.find(id)
      benefit_group = @request_user.benefit_group
      if benefit_group.benefits.include?(benefit)
        benefit_ids = benefit_group.benefits.order(:benefit_type_id, :id).map { |x| x.id }
        benefit_index = benefit_ids.index(benefit.id)
        @image = @image = benefit.image.present? ? url_for(benefit.image.attachment) : root_url + ActionController::Base.helpers.asset_url("news.jpg")
        data << {
          id: benefit.id,
          title: benefit.title,
          url: root_url + "admin/benefit_groups/" + "#{benefit.id}" + "/edit",
          content: formatted_content(benefit, benefit.benefit_group_relationships.first),
          image: @image,
          link: benefit.url,
          benefit_type: benefit.benefit_type.present? ? benefit.benefit_type.name.downcase : "",
          prev_id: benefit_ids[benefit_index - 1].present? ? benefit_ids[benefit_index - 1] : benefit_ids.first,
          next_id: benefit_ids[benefit_index + 1].present? ? benefit_ids[benefit_index + 1] : benefit_ids.last,
        }
      end
      respond_to do |format|
        format.json { render json: data[0] }
        format.js
      end
    end

    def show
      respond_to do |format|
        format.html
        format.json { render json: @benefit }
        format.js
      end
    end

    private

    def formatted_content(benefit, benefit_group_relationship)
      replace_variables = {
        "TIPO": benefit_group_relationship.currency,
        "VALOR": benefit_group_relationship.amount,
      }
      content = benefit.content
      if (content.include?("*|TIPO|*") && content.include?("*|VALOR|*"))
        replace_variables.each do |key, value|
          content = content.gsub!("*|#{key}|*", value)
        end
      end
      content
    end

    def set_tracking
      ahoy.track "Benefit Model", params
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_benefit
      @attachment = General::Benefit.find(params[:id])
    end
  end
end
