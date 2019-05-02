module Admin 
  class SectionsController < AdminController
    before_action :set_section, only: [:show, :edit, :update, :destroy]

    def index
      @sections = General::Section.all
    end

    def show
    end

    def new
      @section = General::Section.new
    end

    def edit
    end

    def create
      @section = General::Section.new(section_params)
      respond_to do |format|
        if @section.save
          format.html { redirect_to admin_section_path(@section), notice: 'Sección fue creada satisfactorialmente.' }
          format.json { render :show, status: :created, location: @section }
        else
          format.html { render :new }
          format.json { render json: @section.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @section.update(section_params)
          format.html { redirect_to admin_section_path(@section), notice: 'Sección fue actualizada satisfactorialmente.' }
          format.json { render :show, status: :ok, location: @section }
        else
          format.html { render :edit }
          format.json { render json: @section.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @section.destroy
      respond_to do |format|
        format.html { redirect_to sections_url, notice: 'Sección fue eliminada satisfactorialmente.' }
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = General::Section.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:section).permit(:title, :description, :position, :url, :image)
    end
  end
end
