module Admin
  class BenefitTypesController < AdminController
    before_action :set_benefit_type, only: [:show, :edit, :update, :destroy]

    def index

      @data_modal = [
        { category: "MI FAMILIA", priority: "1"},
        { category: "MI SALUD", priority: "2"},
        { category: "MIS BONOS Y CRÉDITOS", priority: "3"},
        { category: "MIS PERMISOS ESPECIALES", priority: "4"},
        { category: "MIS CELEBRACIONES", priority: "5"},
        { category: "MIS CONVENIOS", priority: "6"},
        { category: "OTROS", priority: "7"},
      ]

      @benefit_types = General::BenefitType.order(:priority)
    end

    def new
      @benefit_type = General::BenefitType.new
    end

    def show
    
    end

    def edit

    end

    def create
      @benefit_type = General::BenefitType.new(benefit_type_params)
      respond_to do |format|
        if @benefit_type.save
          format.html { redirect_to admin_benefit_types_path(@benefit_type), notice: 'Categoría fue creada con éxito.' }
          format.json { render :show, status: :created, location: @benefit_type }
          format.js
        else
          format.html { render :new }
          format.json { render json: @benefit_type.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def update
      respond_to do |format|
        if @benefit_type.update(benefit_type_params)
          format.html { redirect_to admin_benefit_type_path(@benefit_type), notice: 'Categoría fue actualizada con éxito.' }
          format.json { render :show, status: :ok, location: @benefit_type }
        else
          format.html { render :edit }
          format.json { render json: @benefit_type.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @benefit_type.destroy
      respond_to do |format|
        format.html { redirect_to admin_benefit_types_path, notice: 'Categoría fue eliminada con éxito.' }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_benefit_type
      @benefit_type = General::BenefitType.find(params[:id])
    end

    def benefit_type_params
      params.require(:benefit_type).permit(:name, :priority)
    end
  end
end