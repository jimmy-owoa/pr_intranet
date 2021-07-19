# frozen_string_literal: true

include ActionView::Helpers::NumberHelper

module Api::V1
  class BenefitsController < ApiController
    include ApplicationHelper

    def index
      data = []
      user = @request_user
      
      if user.benefit_group.present?
        data = { benefit_types: [] }
        @benefit_types = General::BenefitType.all.order(:priority)
        @benefit_types.each do |benefit_type|
          allowed_benefits = benefit_type.benefits.allowed_by_benefit_group(user.benefit_group.try(:id)).order(:id)
          next unless allowed_benefits.present?

          benefit_type_hash = {
            name: benefit_type.name,
            benefits: []
          }
          allowed_benefits.each do |benefit|
            benefit_type_hash[:benefits] << {
              id: benefit.id,
              name: benefit.title,
              content: benefit.content,
              image: benefit.get_main_image,
              url: 'admin/benefits/' + benefit.id.to_s + '/edit',
              link: benefit.url
            }
          end
          data[:benefit_types] << benefit_type_hash
        end
      end
      respond_to do |format|
        format.json { render json: data }
      end
    end

    def show
      data = []
      id = params[:id].present? ? params[:id] : nil
      benefit = General::Benefit.find(id)
      benefit_group = @request_user.benefit_group
      if benefit_group.benefits.include?(benefit)
        types = General::BenefitType.where(id: @request_user.benefit_group.benefits.pluck(:benefit_type_id)).order(:priority)
        parents = General::Benefit.where(benefit_type_id: benefit.benefit_type_id)
        benefit_parents = []
        parents.each do |parent|
          benefit_parents << parent if benefit_group.benefits.include?(parent)
        end

        benefit_ids = []

        types.each do |type|
          benefit_ids << benefit_group.benefits.where(benefit_type_id: type.id).order(:id)
        end

        benefit_ids = benefit_ids.flatten.map(&:id)
        benefit_index = benefit_ids.index(benefit.id)

        data = {
          id: benefit.id,
          title: benefit.title,
          # url: root_url + 'admin/benefit_groups/' + benefit.id.to_s + '/edit',
          content: formatted_content(benefit, benefit.benefit_group_relationships.where(benefit_id: benefit.id, benefit_group_id: benefit_group.id ).first),
          image: benefit.get_main_image,
          types: types,
          parents: benefit_parents,
          link: get_benefit_url(benefit, benefit_group.id),
          benefit_type: benefit.benefit_type.present? ? benefit.benefit_type.name.downcase : '',
          prev_id: benefit_ids[benefit_index - 1].present? ? benefit_ids[benefit_index - 1] : benefit_ids.first,
          next_id: benefit_ids[benefit_index + 1].present? ? benefit_ids[benefit_index + 1] : benefit_ids.last,
          is_transactional: benefit.is_transactional,
          breadcrumbs: [
            { to: "/", text: "Inicio", disabled: false, exact: true },
            { to: "/beneficios", text: "Beneficios", disabled: false, exact: true },
            { to: "", text: benefit.title.truncate(30), disabled: true },
          ]
        }
      end
      respond_to do |format|
        format.json { render json: data }
        format.js
      end
    end

    def get_benefit_types
      types = General::BenefitType.where(id: @request_user.benefit_group.benefits.pluck(:benefit_type_id)).pluck(:name)
      respond_to do |format|
        format.json { render json: types }
      end
    end

    private

    def get_benefit_url(benefit, benefit_group_id)
      !benefit.url.present? ? General::BenefitGroupRelationship.where(benefit_id: benefit.id, benefit_group_id: benefit_group_id).first.url : benefit.url
    end

    def formatted_content(benefit, benefit_group_relationship)
      key = benefit_group_relationship.currency.present? ? currency_type_format(benefit_group_relationship.currency) : ''
      val = benefit_group_relationship.amount.present? ? number_to_currency(benefit_group_relationship.amount, unit: '', delimiter: '.', precision: 0) : ''
      replace_variables = {
        "TIPO": key,
        "VALOR": val
      }
      content = benefit.content
      if content.present? && content.include?('*|TIPO|*') && content.include?('*|VALOR|*')
        replace_variables.each do |key, value|
          content = content.gsub!("*|#{key}|*", value)
        end
      end
      fix_content(content) if content.present?
    end

    def currency_type_format(currency)
      case currency
      when 'days'
        'días'
      when 'hours'
        'horas'
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
