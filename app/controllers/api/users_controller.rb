module Api
  class UsersController < ApiController
    before_action :find_user, except: %i[create]

    def show
      render json: @user, status: :ok
    end

    def update
      set_user_data
      if @user.update(user_params)
        add_relations
        @user.set_user_attributes
        render json: "User #{@user.email} updated", status: :ok
      else
        render json: "Error", status: :ok
      end
    end

    def create
      @user = General::User.new(user_params)
      set_user_data
      if @user.save
        add_relations
        @user.set_user_attributes
        render json: "User #{@user.email} created", status: :ok
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      render json: "User deleted", status: :ok
    end

    private

    def set_user_data
      legal_number = InternalAuth.decrypt(params[:user_code_crypted_base64])
      @user.legal_number = legal_number[0...-1]
      @user.legal_number_verification = legal_number[-1]

      country = Location::Country.where(name: params[:office_country]).first_or_create
      region = Location::Region.where(name: params[:office_region], country_id: country.id).first_or_create
      city = Location::City.where(name: params[:office_city], region_id: region.id).first_or_create
      commune = Location::Commune.where(name: params[:office_commune], city_id: city.id).first_or_create
      @user.office = Company::Office.where(address: params[:office_address], commune_id: commune.id).first_or_create

      @user.parent = General::User.where(legal_number: params[:parent_legal_number][0...-1], legal_number_verification: params[:parent_legal_number][-1]).first if params[:parent_legal_number].present?
      @user.benefit_group_id = General::BenefitGroup.find_by_name(params[:benefit_group_name]).try(:id)
      @user.cost_center = Company::CostCenter.where(name: params[:cost_center_name]).first_or_create
      @user.management = Company::Management.where(name: params[:management_name]).first_or_create
      @user.company = Company::Company.where(name: params[:company_name]).first_or_create
      @user.location_id = @user.try(:office).try(:commune).try(:city_id)
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

    def find_user
      if params[:user_code_crypted_base64].present?
        legal_number = InternalAuth.decrypt(params[:user_code_crypted_base64])
        @user = General::User.get_user_by_ln(legal_number)
        if !@user.present?
          render json: { errors: "User not found" }, status: :not_found
        end
      else
        render json: { errors: "User code crypted not present" }, status: :error
      end
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
