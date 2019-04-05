module Admin
  class BenefitGroupsController < AdminController
    before_action :set_benefit_group, only: [:show, :edit, :update, :destroy]

    def index
      @benefit_groups = General::BenefitGroup.paginate(:page => params[:page], :per_page => 10)
    end

    def show
    end

    def new
      @benefit_group = General::BenefitGroup.new
    end

    def edit
    end

    def create
      @benefit_group = General::BenefitGroup.new(benefit_params)
      respond_to do |format|
        if @benefit_group.save
          format.html { redirect_to admin_benefit_path(@benefit_group), notice: 'BenefitGroup was successfully created.'}
          format.json { render :show, status: :created, location: @benefit_group}
        else
          format.html {render :new}
          format.json {render json: @benefit_group.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      respond_to do |format|
        if @benefit_group.update(benefit_params)
          format.html { redirect_to admin_benefit_path(@benefit_group), notice: 'BenefitGroup was successfully updated.'}
          format.json { render :show, status: :ok, location: @benefit_group }
        else
          format.html { render :edit}
          format.json { render json: @benefit_group.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @benefit_group.destroy
      respond_to do |format|
        format.html { redirect_to admin_benefits_path, notice: 'BenefitGroup was successfully destroyed.'}
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_benefit_group
      @benefit_group = General::BenefitGroup.find(params[:id])
    end

    def benefit_params
      params.require(:benefit).permit(:code, :name, :description)
    end
  end
end
