module Admin
  class BenefitsController < ApplicationController
    layout 'admin'
    before_action :set_benefit, only: [:show, :edit, :update, :destroy]

    def index
      @benefits = General::Benefit.all
    end

    def show
    end

    def new
      @benefit = General::Benefit.new
    end

    def edit
    end

    def create
      @benefit = General::Benefit.new(benefit_params)
      respond_to do |format|
        if @benefit.save
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

    def benefit_params
      params.require(:benefit).permit(:title, :content, :image)
    end
  end
end
