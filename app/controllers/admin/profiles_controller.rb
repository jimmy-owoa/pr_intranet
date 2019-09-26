module Admin
  class ProfilesController < AdminController
    before_action :set_profile, only: [:show, :edit, :update, :destroy]

    def index
      @profiles = General::Profile.all
    end

    def show
      @regions = Location::Region.find(General::ProfileAttribute.where(profile: @profile, class_name: "Location::Region").pluck(:value))
      @companies = Company::Company.find(General::ProfileAttribute.where(profile: @profile, class_name: "Company::Company").pluck(:value))
      @benefit_groups = General::BenefitGroup.find(General::ProfileAttribute.where(profile: @profile, class_name: "General::BenefitGroup").pluck(:value))
      @managements = Company::Management.find(General::ProfileAttribute.where(profile: @profile, class_name: "Company::Management").pluck(:value))
      @genders = General::ProfileAttribute.where(profile: @profile, class_name: "Gender").pluck(:value)
      @is_boss = General::ProfileAttribute.where(profile: @profile, class_name: "IsBoss").pluck(:value)
      @employee_classifications = General::ProfileAttribute.where(profile: @profile, class_name: "EmployeeClassification").pluck(:value)
      @cost_centers = Company::CostCenter.find(General::ProfileAttribute.where(profile: @profile, class_name: "Company::CostCenter").pluck(:value))
      @position_classifications = General::ProfileAttribute.where(profile: @profile, class_name: "PositionClassification").pluck(:value)
      @syndicate_members = General::ProfileAttribute.where(profile: @profile, class_name: "SyndicateMember").pluck(:value)
      @contract_types = General::ProfileAttribute.where(profile: @profile, class_name: "ContractType").pluck(:value)
      @roles = General::ProfileAttribute.where(profile: @profile, class_name: "Rol").pluck(:value)
    end

    def new
      @profile = General::Profile.new
      get_data
    end

    def edit
    end

    def create
      @profile = General::Profile.new(profile_params)
      respond_to do |format|
        if @profile.save
          set_class_name_value(params[:regions], "Location::Region")
          set_class_name_value(params[:benefit_groups], "General::BenefitGroup")
          set_class_name_value(params[:companies], "Company::Company")
          set_class_name_value(params[:managements], "Company::Management")
          set_class_name_value(params[:genders], "Gender")
          set_class_name_value(params[:is_boss], "IsBoss")
          set_class_name_value(params[:employee_classifications], "EmployeeClassification")
          set_class_name_value(params[:cost_centers], "Company::CostCenter")
          set_class_name_value(params[:position_classifications], "PositionClassification")
          set_class_name_value(params[:syndicate_members], "SyndicateMember")
          set_class_name_value(params[:contract_types], "ContractType")
          set_class_name_value(params[:roles], "Rol")
          set_class_name_value(params[:schedules], "Schedules")
          set_class_name_value(params[:has_childrens], "HasChildrens")
          set_class_name_value(params[:entry_dates], "EntryDate")
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
      @is_boss = ["Si", "No"]
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
      @has_childrens = ["Si", "No"]
      @entry_dates = users.pluck(:date_entry).uniq.reject(&:blank?).sort
    end

    def set_class_name_value(values, class_name)
      if values 
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
