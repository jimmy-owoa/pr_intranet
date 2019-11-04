module Admin
  class BenefitsController < AdminController
    before_action :set_benefit, only: [:show, :edit, :update, :destroy]

    def index
      @benefits = General::Benefit.order(created_at: :desc).user_benefits(current_user).paginate(:page => params[:page], :per_page => 10)
    end

    def show
    end

    def edit
    end

    def create
      @benefit = General::Benefit.new(benefit_params)
      respond_to do |format|
        if @benefit.save
          set_benefit_group
          format.html { redirect_to admin_benefit_path(@benefit), notice: "Beneficio fue creado con éxito." }
          format.json { render :show, status: :created, location: @benefit }
        else
          format.html { render :new }
          format.json { render json: @benefit.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @benefit.update(benefit_params)
          set_benefit_group
          format.html { redirect_to admin_benefits_path, notice: "Beneficio fue actualizado con éxito." }
          format.json { render :show, status: :ok, location: @benefit }
        else
          format.html { render :edit }
          format.json { render json: @benefit.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @benefit.destroy
      respond_to do |format|
        format.html { redirect_to admin_benefits_path, notice: "Beneficio fue eliminado con éxito." }
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
      params.require(:benefit).permit(:title, :content, :url, :code, :alias, :image, :benefit_type_id, :is_special, benefit_groups_ids: [])
    end
  end
end
