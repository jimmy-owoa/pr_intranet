# frozen_string_literal: true

module Admin
  class BenefitsController < AdminController
    before_action :set_benefit, only: %i[show edit update destroy]

    def index
      @benefits = General::Benefit.order(:benefit_type_id).user_benefits(current_user)
    end

    def show; end

    def edit
      parent_id = General::Menu.where(title: "Mis beneficios").first.id

      @grouped_options = []
      menus = General::Menu.where(parent_id: parent_id)
      menus.each do |menu|
        @grouped_options << [menu.title, menu.id]
      end
    end

    def create
      @benefit = General::Benefit.new(benefit_params)
      respond_to do |format|
        if @benefit.save
          set_benefit_group
          format.html { redirect_to admin_benefit_path(@benefit), notice: 'Beneficio fue creado con éxito.' }
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
          format.html { redirect_to admin_benefits_path, notice: 'Beneficio fue actualizado con éxito.' }
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
        format.html { redirect_to admin_benefits_path, notice: 'Beneficio fue eliminado con éxito.' }
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
          unless @benefit.benefit_groups.pluck(:name).include?(bg)
            groups << General::BenefitGroup.find_or_create_by(name: bg)
          end
        end
        @benefit.benefit_groups << groups
      end
    end

    def benefit_params
      params.require(:benefit).permit(:title, :content, :url, :code, :alias, :image, :benefit_type_id, :is_special, :menu_id, benefit_groups_ids: [])
    end
  end
end
