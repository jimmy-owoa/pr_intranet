module Admin
  class BenefitsController < AdminController
    before_action :set_benefit, only: [:show, :edit, :update, :destroy]

    def index
        @benefits = General::Benefit.user_benefits(current_user)
    end

    def show
    end

    def new
      @benefit = General::Benefit.new
      @benefit.terms.build
    end

    def edit
    end

    def create
      @benefit = General::Benefit.new(benefit_params)
      respond_to do |format|
        if @benefit.save
          set_benefit_group
          format.html { redirect_to admin_benefit_path(@benefit), notice: 'Benefit was successfully created.'}
          format.json { render :show, status: :created, location: @benefit}
        else
          format.html {render :new}
          format.json {render json: @benefit.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      respond_to do |format|
        if @benefit.update(benefit_params)
          set_benefit_group
          format.html { redirect_to admin_benefit_path(@benefit), notice: 'Benefit was successfully updated.'}
          format.json { render :show, status: :ok, location: @benefit }
        else
          format.html { render :edit}
          format.json { render json: @benefit.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @benefit.destroy
      respond_to do |format|
        format.html { redirect_to admin_benefits_path, notice: 'Benefit was successfully destroyed.'}
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_benefit
      @benefit = General::Benefit.find(params[:id])
    end

    def set_benefit_group
      # Getting terms_names from the form (tags)
      benefit_groups = params[:benefit_groups]
      groups = []
      if benefit_groups.present?
        benefit_groups.uniq.each do |bg|
          # groups << General::BenefitGroup.where(name: bg)
          groups << General::BenefitGroup.find_or_create_by(name: bg) unless @benefit.benefit_groups.pluck(:name).include?(bg)
        end
        @benefit.benefit_groups << groups
      end   
    end    

    def benefit_params
      params.require(:benefit).permit(:title, :content, :image, benefit_groups_ids: [])
    end
  end
end
