module Api
  class BenefitsController < ApiController
    before_action :find_benefit, except: %i[create index]

    def index
      @benefits = General::Benefit.all
      render json: @benefits, status: :ok
    end

    def show
      render json: @benefit, status: :ok
    end

    def create
      # benefit_groups_ids = General::BenefitGroup.where(name: params[:benefit_groups].values).pluck(:id)
      benefit_group = General::BenefitGroup.where(name: params["name"], code: params["code"]).first_or_create
      data = { beneficiary_group: benefit_group, benefits: [] }
      params["benefits"].each do |benefit|
        if benefit["name"].present?
          if /^(\s)*bono/.match(benefit["name"].downcase)
            benefit_type = 1
          elsif /^(\s)*crédito/.match(benefit["name"].downcase)
            benefit_type = 2
          elsif /^(\s)*seguro/.match(benefit["name"].downcase)
            benefit_type = 3
          elsif /^(\s)*permiso/.match(benefit["name"].downcase)
            benefit_type = 4
          end
        end
        record = General::Benefit.where(title: benefit["name"], code: benefit["code"], benefit_type_id: benefit_type).first_or_create
        if benefit["variables"].present?
          benefit["variables"].each do |variable|
            var = General::BenefitGroupRelationship.where(amount: variable["amount"], currency: variable["currency"], url: benefit["url"], benefit_group: benefit_group).first_or_create
            record.benefit_group_relationships << var unless record.benefit_group_relationships.include?(var)
          end
        end
        data[:benefits] << record
      end
      render json: data, status: :ok
      # @benefit = General::Benefit.new(benefit_params)
    end

    private

    def find_benefit
      @benefit = General::Benefit.find_by_title!(params[:title])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "Benefit not found" }, status: :not_found
    end

    def benefit_params
      params.permit(:beneficiary_group)
    end
  end
end
