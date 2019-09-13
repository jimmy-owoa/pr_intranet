module Admin 
  class ProfilesController < AdminController
    before_action :set_profile, only: [:show, :edit, :update, :destroy]

    def index
      @profiles = General::Profile.all
    end

    def show
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
          format.html { redirect_to admin_profile_path(@profile), notice: 'Profile fue creada con éxito.'}
          format.json { render :show, status: :created, location: @profile}
          format.js
        else
          format.html {render :new}
          format.json {render json: @profile.errors, status: :unprocessable_entity}
          format.js
        end
      end
    end

    def update
      respond_to do |format|
        if @profile.update(profile_params)
          format.html { redirect_to admin_profile_path(@profile), notice: 'Profile fue actualizada con éxito.'}
          format.json { render :show, status: :ok, location: @profile }
        else
          format.html { render :edit}
          format.json { render json: @profile.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @profile.destroy
      respond_to do |format|
        format.html { redirect_to admin_profiles_path, notice: 'Profile fue eliminada con éxito.'}
        format.json { head :no_content }
      end
    end

    private

    def get_data
      start = Time.now
      users = General::User.all
      @genders = ["Masculino","Femenino"]
      @is_boss = users.pluck(:is_boss).uniq.reject(&:blank?).sort
      @user_class = users.pluck(:employee_classification).uniq.reject(&:blank?).sort
      @regions = Location::Region.pluck(:name).uniq.reject(&:blank?).sort
      @benefit_groups = General::BenefitGroup.pluck(:name).sort
      @companies = Company::Company.pluck(:name).sort
      @managements = Company::Management.pluck(:name).sort
      @cost_centers = Company::CostCenter.pluck(:name).sort
      @position_classifications = users.pluck(:position_classification).uniq.reject(&:blank?).sort
      @syndicate_members = users.pluck(:syndicate_member).uniq.reject(&:blank?).sort
      @contract_types = users.pluck(:contract_type).uniq.reject(&:blank?).sort
      @roles = users.pluck(:rol).uniq.reject(&:blank?).sort
      @schedules = users.pluck(:schedule).uniq.reject(&:blank?).sort
      @has_childrens = ["Si", "No"]
      @date_entries = users.pluck(:date_entry).uniq.reject(&:blank?).sort
      Rails.logger.info "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& " + (Time.now - start).to_s
    end

    def set_profile
      @profile = General::Profile.find(params[:id])
    end

    def profile_params
      params.require(:profile).permit(:name)
    end
  end
end