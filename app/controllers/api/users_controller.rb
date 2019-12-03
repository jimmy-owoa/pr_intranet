module Api
  class UsersController < ApiController
    before_action :find_user, except: %i[create index]

    def show
      render json: @user, status: :ok
    end

    def update
      set_user_data
      if @user.update(user_params)
        add_relations
        render json: @user, status: :ok
      else
        render json: "User not found", status: :ok
      end
    end

    def create
      @user = General::User.new(user_params)
      set_user_data
      if @user.save
        add_relations
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    private

    def set_user_data
      office_address = params[:office_address]
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
      cost_center = Company::CostCenter.where(name: params[:cost_center_name]).first_or_create
      management = Company::Management.where(name: params[:management_name]).first_or_create
      company = Company::Company.where(name: params[:company_name]).first_or_create
      @user.company = company
      @user.management = management
      @user.office = office
      @user.cost_center = cost_center
      @user.benefit_group_id = benefit_group_id if benefit_group_id.present?
      @user.parent = parent if parent.present?
      @user.location_id = @user.try(:office).try(:commune).try(:city_id)
      legal_number = InternalAuth.decrypt(params[:user_code_crypted_base64])
      @user.legal_number = legal_number[0...-1]
      @user.legal_number_verification = legal_number[-1]
    end

    def add_relations
      user_education_ids = []
      JSON.parse(params[:education]).each do |institution|
        education_state = PersonalData::EducationState.where(name: institution[1]["Estado"]).first_or_create
        education_institution = PersonalData::EducationState.where(name: institution[1]["Estado"]).first_or_create
        user_education_ids << PersonalData::UserEducation.where(user_id: @user.id, education_institution_id: education_institution.id, education_state_id: education_state.id).first_or_create.id
      end

      user_language_ids = []
      JSON.parse(params[:languages]).each do |lang|
        level = PersonalData::LanguageLevel.where(name: lang[1]["Nivel"]).first_or_create
        language = PersonalData::Language.where(name: lang[1]["Idioma"]).first_or_create
        user_language_ids << PersonalData::UserLanguage.where(user_id: @user.id, language_id: language.id, language_level_id: level.id).first_or_create.id
      end
      @user.user_language_ids = user_language_ids

      family_member_ids = []
      JSON.parse(params[:family_group]).each do |member|
        family_member_ids << PersonalData::FamilyMember.where(user_id: @user.id, relation: member[1]["Relación"], birthdate: member[1]["Fecha nacimiento de familiar"], gender: member[1]["Sexo de familiar"], name: member[1]["Nombre de familiar"]).first_or_create.id
      end
      @user.family_member_ids = family_member_ids
    end

    # def find_user
    #   @user = General::User.find_by_legal_number!(params[:legal_number])
    # rescue ActiveRecord::RecordNotFound
    #   render json: { errors: "User not found" }, status: :not_found
    # end

    def find_user
      if params[:user_code_crypted_base64].present?
        legal_number = InternalAuth.decrypt(params[:user_code_crypted_base64])
        @user = General::User.get_user_by_ln(legal_number)
      else
        render json: { errors: "User code crypted not present" }, status: :error
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
