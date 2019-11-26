module Api
  class UsersController < ApiController
    before_action :find_user, except: %i[create index]

    def show
      render json: @user, status: :ok
    end

    def update
      set_user_data
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: "User not found", status: :ok
      end
    end

    def create
      @user = General::User.new(user_params)
      set_user_data
      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    private

    def set_user_data
      office_address = params[:office_address].gsub(";", ",") if params[:office_address].present?
      office_commune = params[:office_commune]
      office_city = params[:office_city]
      office_region = params[:office_region]
      office_country = params[:office_country]

      country = Location::Country.where(name: office_country).first_or_create
      region = Location::Region.where(name: office_region, country_id: country.id).first_or_create
      city = Location::City.where(name: office_city, region_id: region.id).first_or_create
      commune = Location::Commune.where(name: office_commune, city_id: city.id).first_or_create
      office = Company::Office.where(address: office_address, commune_id: commune.id).first_or_create

      parent = General::User.where(legal_number: params[:parent_legal_number][0...-1], legal_number_verification: params[:parent_legal_number][-1]).first if params[:parent_legal_number].present?
      benefit_group_id = General::BenefitGroup.find_by_name(params[:benefit_group_name]).try(:id)
      cost_center = Company::CostCenter.where(name: params[:cost_center]).first_or_create
      management = Company::Management.where(name: params[:management]).first_or_create
      company = Company::Company.where(name: params[:company]).first_or_create
      @user.company = company
      @user.management = management
      @user.office = office
      @user.cost_center = cost_center
      @user.benefit_group_id = benefit_group_id if benefit_group_id.present?
      @user.parent = parent if parent.present?
      @user.location_id = @user.try(:office).try(:commune).try(:city_id)
    end

    # def find_user
    #   @user = General::User.find_by_legal_number!(params[:legal_number])
    # rescue ActiveRecord::RecordNotFound
    #   render json: { errors: "User not found" }, status: :not_found
    # end

    def find_user
      if params[:encrypted_data].present?
        legal_number = InternalAuth.decrypt(params[:encrypted_data])
        @user = General::User.find_by_legal_number!(legal_number[0...-1])
      else
        render json: { errors: "Encrypted data not present" }, status: :error
      end
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "User not found" }, status: :not_found
    end

    def user_params
      params.permit(:id, :email, :name, :last_name, :last_name2, :address, :position,
                    :active, :annexed, :birthday, :date_entry, :password, :password_confirmation,
                    :show_birthday, :children_count, :legal_number, :legal_number_verification,
                    :nt_user, :gender, :position_classification, :employee_classification,
                    :syndicate_member, :civil_status, :contract_type, :schedule, :is_boss, :handicapped, :has_children,
                    :favorite_name, :address, :rol)
    end
  end
end
