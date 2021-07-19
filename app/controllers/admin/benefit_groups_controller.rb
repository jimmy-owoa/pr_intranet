# frozen_string_literal: true

module Admin
  class BenefitGroupsController < AdminController
    before_action :set_benefit_group, only: [:show]

    def index
      @benefit_groups = General::BenefitGroup.paginate(page: params[:page], per_page: 10)
      @benefit_group = General::BenefitGroup.benefit_group_user(current_user)
    end

    def show; end

    # def new
    #   @benefit_group = General::BenefitGroup.new
    # end

    # def edit
    # end

    # def create
    #   @benefit_group = General::BenefitGroup.new(benefit_params)
    #   respond_to do |format|
    #     if @benefit_group.save
    #       format.html { redirect_to admin_benefit_path(@benefit_group), notice: 'Grupo de beneficio fue creado con éxito.'}
    #       format.json { render :show, status: :created, location: @benefit_group}
    #     else
    #       format.html {render :new}
    #       format.json {render json: @benefit_group.errors, status: :unprocessable_entity}
    #     end
    #   end
    # end

    # def update
    #   respond_to do |format|
    #     if @benefit_group.update(benefit_params)
    #       format.html { redirect_to admin_benefit_path(@benefit_group), notice: 'Grupo de beneficio fue actualizado con éxito.'}
    #       format.json { render :show, status: :ok, location: @benefit_group }
    #     else
    #       format.html { render :edit}
    #       format.json { render json: @benefit_group.errors, status: :unprocessable_entity}
    #     end
    #   end
    # end

    # def destroy
    #   @benefit_group.destroy
    #   respond_to do |format|
    #     format.html { redirect_to admin_benefit_groups_path, notice: 'Grupo de beneficio fue eliminado con éxito.'}
    #     format.json { head :no_content }
    #   end
    # end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_benefit_group
      @benefit_group = General::BenefitGroup.find(params[:id])
    end

    def benefit_params
      params.require(:benefit_group).permit(:code, :name, :description)
    end
  end
end
