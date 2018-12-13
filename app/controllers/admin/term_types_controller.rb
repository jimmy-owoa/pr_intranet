module Admin
  class TermTypesController < ApplicationController
    before_action :set_term_type, only: [:show, :edit, :update, :destroy]

    def index
      @term_types = General::TermType.all
    end

    def show
    end

    def new
      @term_type = General::TermType.new
    end

    def edit
    end

    def create
      @term_type = General::TermType.new(term_type_params)
      respond_to do |format|
        if @term_type.save
          format.html { redirect_to edit_admin_term_type_path(@term_type), notice: 'TermType was successfully created.'}
          format.json { render :show, status: :created, location: @term_type}
        else
          format.html {render :new}
          format.json {render json: @term_type.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      respond_to do |format|
        if @term_type.update(term_type_params)
          format.html { redirect_to admin_term_type_path(@term_type), notice: 'TermType was successfully updated.'}
          format.json { render :show, status: :ok, location: @term_type }
        else
          format.html { render :edit}
          format.json { render json: @term_type.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @term_type.destroy
      respond_to do |format|
        format.html { redirect_to admin_term_types_path, notice: 'TermType was successfully destroyed.'}
        format.json { head :no_content }
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_term_type
      @term_type = General::TermType.find(params[:id])
    end

    def term_type_params
      params.require(:term_type).permit(:name)
    end
  end
end
