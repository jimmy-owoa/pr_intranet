include ActionView::Helpers::NumberHelper

module Api::V1
  class BenefitsController < ApiController
    def index
      user = @request_user

      if user.benefit_group.present?
        data_benefit_types = []
        @benefit_types = General::BenefitType.all
        @benefit_types.each do |benefit_type|
          allowed_benefits = benefit_type.benefits.allowed_by_benefit_group(user.benefit_group.try(:id))
          if allowed_benefits.present?
            benefit_type_hash = {
              name: benefit_type.name,
              benefits: [],
            }
            allowed_benefits.each do |benefit|
              benefit_type_hash[:benefits] << {
                id: benefit.id,
                name: benefit.title,
                content: benefit.content,
                image: benefit.image.attached? ? url_for(benefit.image) : ActionController::Base.helpers.asset_path("benefit.jpg"),
                url: "admin/benefits/" + "#{benefit.id}" + "/edit",
                link: benefit.url,
              }
            end
            data_benefit_types << benefit_type_hash
          end
        end
      end

      data = { status: "ok", results_length: data_benefit_types.count, benefit_types: data_benefit_types }
      render json: data, status: :ok
    end

    def benefit
      id = params[:id].present? ? params[:id] : nil
      if id.present?
        benefit = General::Benefit.find(id)
        benefit_group = @request_user.benefit_group
        if benefit_group.benefits.include?(benefit)
          benefit_ids = benefit_group.benefits.order(:benefit_type_id, :id).map { |x| x.id }
          benefit_index = benefit_ids.index(benefit.id)
          types = General::BenefitType.where(id: @request_user.benefit_group.benefits.pluck(:benefit_type_id))
          parents = General::Benefit.where(benefit_type_id: benefit.benefit_type_id)
          benefit_parents = []
          parents.each do |parent|
            if benefit_group.benefits.include?(parent)
              benefit_parents << parent
            end
          end
          @image = benefit.image.attached? ? url_for(benefit.image.attachment) : ActionController::Base.helpers.asset_path("benefit.jpg")
          data_benefit = {
            id: benefit.id,
            title: benefit.title,
            # url: root_url + "admin/benefit_groups/" + "#{benefit.id}" + "/edit",
            content: formatted_content(benefit, benefit.benefit_group_relationships.first),
            image: @image,
            types: types,
            parents: benefit_parents,
            link: get_benefit_url(benefit, benefit_group.id),
            benefit_type: benefit.benefit_type.present? ? benefit.benefit_type.name.downcase : "",
          }
          prev_id = benefit_ids[benefit_index - 1].present? ? benefit_ids[benefit_index - 1] : benefit_ids.first
          next_id = benefit_ids[benefit_index + 1].present? ? benefit_ids[benefit_index + 1] : benefit_ids.last
        end
        breadcrumbs = [
          { href: "/", text: "Inicio" },
          { href: "/beneficios", text: "Beneficios" },
          { href: "#", text: benefit.title.truncate(30), disabled: true },
        ]
  
        data = { status: "ok", prev_id: prev_id, next_id: next_id, breadcrumbs: breadcrumbs, benefit: data_benefit }
        render json: data, status: :ok
      else
        render json: { status: "error", message: "bad request" }, status: :bad_request
      end
    end

    private

    def get_benefit_url(benefit, benefit_group_id)
      !benefit.url.present? ? General::BenefitGroupRelationship.where(benefit_id: benefit.id, benefit_group_id: benefit_group_id).first.url : benefit.url
    end

    def formatted_content(benefit, benefit_group_relationship)
      key = benefit_group_relationship.currency.present? ? currency_type_format(benefit_group_relationship.currency) : ""
      val = benefit_group_relationship.amount.present? ? number_to_currency(benefit_group_relationship.amount, unit: "", delimiter: ".", precision: 0) : ""
      replace_variables = {
        "TIPO": key,
        "VALOR": val,
      }
      content = benefit.content
      if (content.present? && content.include?("*|TIPO|*") && content.include?("*|VALOR|*"))
        replace_variables.each do |key, value|
          content = content.gsub!("*|#{key}|*", value)
        end
      end
      content
    end

    def currency_type_format(currency)
      case currency
      when "days"
        "días"
      when "hours"
        "horas"
      else
        currency
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_benefit
      @attachment = General::Benefit.find(params[:id])
    end
  end
end
