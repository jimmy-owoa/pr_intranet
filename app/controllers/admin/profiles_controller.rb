module Admin
  class ProfilesController < AdminController
    before_action :set_profile, only: [:show, :edit, :update, :destroy]

    def index
      @profiles = General::Profile.all
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
          set_class_name_value(params[:regions], "location_region")
          set_class_name_value(params[:benefit_groups], "general_benefit_group")
          set_class_name_value(params[:companies], "company")
          set_class_name_value(params[:managements], "company_management")
          set_class_name_value(params[:genders], "gender")
          set_class_name_value(params[:is_boss], "is_boss")
          set_class_name_value(params[:employee_classifications], "employee_classification")
          set_class_name_value(params[:cost_centers], "company_cost_center")
          set_class_name_value(params[:position_classifications], "position_classification")
          set_class_name_value(params[:syndicate_members], "syndicate_member")
          set_class_name_value(params[:contract_types], "contract_type")
          set_class_name_value(params[:roles], "rol")
          set_class_name_value(params[:schedules], "schedule")
          set_class_name_value(params[:has_children], "has_children")
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
          set_class_name_value(params[:regions], "location_region")
          set_class_name_value(params[:benefit_groups], "general_benefit_group")
          set_class_name_value(params[:companies], "company")
          set_class_name_value(params[:managements], "company_management")
          set_class_name_value(params[:genders], "gender")
          set_class_name_value(params[:is_boss], "is_boss")
          set_class_name_value(params[:employee_classifications], "employee_classification")
          set_class_name_value(params[:cost_centers], "company_cost_center")
          set_class_name_value(params[:position_classifications], "position_classification")
          set_class_name_value(params[:syndicate_members], "syndicate_member")
          set_class_name_value(params[:contract_types], "contract_type")
          set_class_name_value(params[:roles], "rol")
          set_class_name_value(params[:schedules], "schedule")
          set_class_name_value(params[:has_children], "has_children")
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

    def get_data
      users = General::User.all
      @genders = ["masculino", "femenino"]
      @is_boss = ["si", "no"]
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
      @has_children = ["si", "no"]
    end

    def get_selected
      @selected_genders = @profile.profile_attributes.where(class_name: "gender").pluck(:value)
      @selected_boss = @profile.profile_attributes.where(class_name: "is_boss").pluck(:value)
      @selected_employee_classifications = @profile.profile_attributes.where(class_name: "employee_classification").pluck(:value)
      @selected_companies = @profile.profile_attributes.where(class_name: "company").pluck(:value)
      @selected_regions = @profile.profile_attributes.where(class_name: "location_region").pluck(:value)
      @selected_benefit_groups = @profile.profile_attributes.where(class_name: "general_benefit_group").pluck(:value)
      @selected_managements = @profile.profile_attributes.where(class_name: "company_management").pluck(:value)
      @selected_cost_centers = @profile.profile_attributes.where(class_name: "company_cost_center").pluck(:value)
      @selected_position_classifications = @profile.profile_attributes.where(class_name: "position_classification").pluck(:value)
      @selected_syndicate_members = @profile.profile_attributes.where(class_name: "syndicate_member").pluck(:value)
      @selected_contract_types = @profile.profile_attributes.where(class_name: "contract_type").pluck(:value)
      @selected_roles = @profile.profile_attributes.where(class_name: "rol").pluck(:value)
      @selected_schedules = @profile.profile_attributes.where(class_name: "schedule").pluck(:value)
      @selected_has_children = @profile.profile_attributes.where(class_name: "has_children").pluck(:value)
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
                                             entry_dates: [])
    end
  end
end
