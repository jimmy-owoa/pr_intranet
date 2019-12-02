module Admin
  class ProfilesController < AdminController
    before_action :set_profile, only: [:show, :edit, :update, :destroy]

    def index
      @profiles = General::Profile.order(created_at: :desc)
    end

    def show
      @regions = Location::Region.find(General::ProfileAttribute.where(profile: @profile, class_name: "location_region").pluck(:value))
      @companies = Company::Company.find(General::ProfileAttribute.where(profile: @profile, class_name: "company").pluck(:value))
      @benefit_groups = General::BenefitGroup.find(General::ProfileAttribute.where(profile: @profile, class_name: "general_benefit_group").pluck(:value))
      @managements = Company::Management.find(General::ProfileAttribute.where(profile: @profile, class_name: "company_management").pluck(:value))
      @genders = General::ProfileAttribute.where(profile: @profile, class_name: "gender").pluck(:value)
      @is_boss = General::ProfileAttribute.where(profile: @profile, class_name: "is_boss").pluck(:value)
      @employee_classifications = General::ProfileAttribute.where(profile: @profile, class_name: "employee_classification").pluck(:value)
      @cost_centers = Company::CostCenter.find(General::ProfileAttribute.where(profile: @profile, class_name: "company_cost_center").pluck(:value))
      @position_classifications = General::ProfileAttribute.where(profile: @profile, class_name: "position_classification").pluck(:value)
      @syndicate_members = General::ProfileAttribute.where(profile: @profile, class_name: "syndicate_member").pluck(:value)
      @contract_types = General::ProfileAttribute.where(profile: @profile, class_name: "contract_type").pluck(:value)
      @roles = General::ProfileAttribute.where(profile: @profile, class_name: "rol").pluck(:value)
      @schedules = General::ProfileAttribute.where(profile: @profile, class_name: "schedule").pluck(:value)
      @has_children = General::ProfileAttribute.where(profile: @profile, class_name: "has_children").pluck(:value)
      @office_countries = General::ProfileAttribute.where(profile: @profile, class_name: "office_country").pluck(:value)
      @office_cities = General::ProfileAttribute.where(profile: @profile, class_name: "office_city").pluck(:value)
      @office_regions = General::ProfileAttribute.where(profile: @profile, class_name: "office_region").pluck(:value)
    end

    def users_list
      @profile = General::Profile.includes(user_profiles: :user).find(params[:id])
      render xlsx: "users_list.xlsx.axlsx", filename: "listado de usuarios #{@profile.name + " " + l(Date.today, format: "%A %d %B %Y")}.xlsx"
    end

    def new
      @profile = General::Profile.new
      get_data
    end

    def edit
      get_data
      get_selected
    end

    def create
      @profile = General::Profile.new(profile_params)
      respond_to do |format|
        if @profile.save
          set_profile_attributes
          @profile.set_users
          format.html { redirect_to admin_profile_path(@profile), notice: "Profile fue creada con éxito." }
          format.json { render :show, status: :created, location: @profile }
          format.js
        else
          format.html { render :new }
          format.json { render json: @profile.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def update
      respond_to do |format|
        if @profile.update(profile_params)
          set_profile_attributes
          @profile.set_users
          format.html { redirect_to admin_profile_path(@profile), notice: "Profile fue actualizada con éxito." }
          format.json { render :show, status: :ok, location: @profile }
        else
          format.html { render :edit }
          format.json { render json: @profile.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @profile.destroy
      respond_to do |format|
        format.html { redirect_to admin_profiles_path, notice: "Profile fue eliminada con éxito." }
        format.json { head :no_content }
      end
    end

    private

    def set_profile_attributes
      set_class_name_value(params[:regions], "region")
      set_class_name_value(params[:benefit_groups], "benefit_group")
      set_class_name_value(params[:companies], "company")
      set_class_name_value(params[:managements], "management")
      set_class_name_value(params[:genders], "gender")
      set_class_name_value(params[:is_boss], "is_boss")
      set_class_name_value(params[:employee_classifications], "employee_classification")
      set_class_name_value(params[:cost_centers], "cost_center")
      set_class_name_value(params[:position_classifications], "position_classification")
      set_class_name_value(params[:syndicate_members], "syndicate_member")
      set_class_name_value(params[:contract_types], "contract_type")
      set_class_name_value(params[:roles], "rol")
      set_class_name_value(params[:schedules], "schedule")
      set_class_name_value(params[:has_children], "has_children")
      set_class_name_value(params[:office_countries], "office_country")
      set_class_name_value(params[:office_cities], "office_city")
      set_class_name_value(params[:office_regions], "office_region")
    end

    def get_data
      users = General::User.all
      @genders = ["Masculino", "Femenino"]
      @is_boss = { "Si": 1, "No": 0 }
      @employee_classifications = users.pluck(:employee_classification).uniq.reject(&:blank?).sort
      @regions = Location::Region.pluck(:id, :name).uniq.reject(&:blank?).sort
      @benefit_groups = General::BenefitGroup.pluck(:id, :name).sort
      @companies = Company::Company.pluck(:id, :name).sort
      @managements = Company::Management.pluck(:id, :name).sort
      @cost_centers = Company::CostCenter.pluck(:id, :name).sort
      @position_classifications = users.pluck(:position_classification).uniq.reject(&:blank?).sort
      @syndicate_members = users.pluck(:syndicate_member).uniq.reject(&:blank?).sort
      @contract_types = users.pluck(:contract_type).uniq.reject(&:blank?).sort
      @roles = users.pluck(:rol).uniq.reject(&:blank?).sort
      @schedules = users.pluck(:schedule).uniq.reject(&:blank?).sort
      @has_children = { "Si": 1, "No": 0 }
      @office_countries = Location::Country.where.not(name: "").order(:name).map { |country| [country.name, country.id] }
      @office_cities = Location::City.where.not(name: "").order(:name).map { |city| [city.name, city.id] }
      @office_regions = Location::Region.where.not(name: "").order(:name).map { |region| [region.name, region.id] }
    end

    def get_selected
      @selected_genders = @profile.profile_attributes.where(class_name: "gender").pluck(:value)
      @selected_boss = @profile.profile_attributes.where(class_name: "is_boss").pluck(:value)
      @selected_employee_classifications = @profile.profile_attributes.where(class_name: "employee_classification").pluck(:value)
      @selected_companies = @profile.profile_attributes.where(class_name: "company").pluck(:value)
      @selected_regions = @profile.profile_attributes.where(class_name: "location_region").pluck(:value)
      @selected_benefit_groups = @profile.profile_attributes.where(class_name: "benefit_group").pluck(:value)
      @selected_managements = @profile.profile_attributes.where(class_name: "management").pluck(:value)
      @selected_cost_centers = @profile.profile_attributes.where(class_name: "cost_center").pluck(:value)
      @selected_position_classifications = @profile.profile_attributes.where(class_name: "position_classification").pluck(:value)
      @selected_syndicate_members = @profile.profile_attributes.where(class_name: "syndicate_member").pluck(:value)
      @selected_contract_types = @profile.profile_attributes.where(class_name: "contract_type").pluck(:value)
      @selected_roles = @profile.profile_attributes.where(class_name: "rol").pluck(:value)
      @selected_schedules = @profile.profile_attributes.where(class_name: "schedule").pluck(:value)
      @selected_has_children = @profile.profile_attributes.where(class_name: "has_children").pluck(:value)
      @selected_office_countries = @profile.profile_attributes.where(class_name: "office_country").pluck(:value)
      @selected_office_cities = @profile.profile_attributes.where(class_name: "office_city").pluck(:value)
      @selected_office_regions = @profile.profile_attributes.where(class_name: "office_region").pluck(:value)
    end

    def set_class_name_value(values, class_name)
      if values
        #Update
        values.each do |value|
          General::ProfileAttribute.where(class_name: class_name, profile_id: @profile.id).where.not(value: value).each do |del|
            del.delete
          end
        end
        #Create
        values.each do |value|
          General::ProfileAttribute.where(class_name: class_name, value: value, profile_id: @profile.id).first_or_create
        end
      end
    end

    def set_profile
      @profile = General::Profile.find(params[:id])
    end

    def profile_params
      params.require(:profile).permit(:name, regions: [], benefit_groups: [], companies: [], managements: [], genders: [], is_boss: [],
                                             employee_classifications: [], cost_centers: [], position_classifications: [],
                                             syndicate_members: [], contract_types: [], roles: [], schedules: [], has_childrens: [],
                                             entry_dates: [], office_cities: [], office_countries: [], office_regions: [])
    end
  end
end
