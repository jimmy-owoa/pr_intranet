module Admin 
  class SectionsController < ApplicationController
    before_action :set_section, only: [:show, :edit, :update, :destroy]
    layout 'admin'
    # GET /admin/sections
    # GET /admin/sections.json
    def index
      @sections = General::Section.all
    end

    # GET /admin/sections/1
    # GET /admin/sections/1.json
    def show
    end

    # GET /admin/sections/new
    def new
      @section = General::Section.new
    end

    # GET /admin/sections/1/edit
    def edit
    end

    # POST /admin/sections
    # POST /admin/sections.json
    def create
      @section = General::Section.new(section_params)
      respond_to do |format|
        if @section.save
          format.html { redirect_to admin_section_path(@section), notice: 'Section was successfully created.' }
          format.json { render :show, status: :created, location: @section }
        else
          format.html { render :new }
          format.json { render json: @section.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/sections/1
    # PATCH/PUT /admin/sections/1.json
    def update
      respond_to do |format|
        if @section.update(section_params)
          format.html { redirect_to admin_section_path(@section), notice: 'Section was successfully updated.' }
          format.json { render :show, status: :ok, location: @section }
        else
          format.html { render :edit }
          format.json { render json: @section.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/sections/1
    # DELETE /admin/sections/1.json
    def destroy
      @section.destroy
      respond_to do |format|
        format.html { redirect_to sections_url, notice: 'Section was successfully destroyed.' }
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
