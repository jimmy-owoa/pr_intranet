module Api
  class BenefitsController < ApiController
    before_action :find_beneficiary_group, except: %i[create index]
    before_action :validate

    def show
      data = { beneficiary_group: { name: @beneficiary_group.name, code: @beneficiary_group.code, benefits: [] } }
      @beneficiary_group.benefits.each { |benefit| data[:beneficiary_group][:benefits] << benefit }
      render json: data, status: :ok
    end

    def destroy
      General::BenefitGroup.where(name: params["name"], code: params["code"]).last.delete
      render json: "Beneficiary group deleted", status: :ok
    end

    def create
      benefit_group = General::BenefitGroup.where(name: params["name"], code: params["code"]).first_or_create
      data = { beneficiary_group: benefit_group, benefits: [] }
      JSON.parse(params["benefits"]).each do |benefit|
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
    end

    private

    def validate
      render json: "Unauthorized", status: 200 if InternalAuth.decrypt(request.headers["Authorization"]) != "exa"
    end

    def find_beneficiary_group
      @beneficiary_group = General::BenefitGroup.where(name: params[:name], code: params[:code]).last
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "Beneficiary group not found" }, status: :not_found
    end

    def benefit_params
      params.permit(:beneficiary_group)
    end
  end
end
