module Admin
  class ExpenseReportCategoriesController < AdminController
    before_action :set_category, only: [:edit, :show, :destroy, :update]
    before_action :check_admin

    def index
      if current_user.has_role? :admin
        @categories = ExpenseReport::Category.all
      else
        @categories = current_user.help_categories
      end
    end

    def new
      @category = ExpenseReport::Category.new
    end

    def edit
    end

    def show

    end

    def create
       @category = ExpenseReport::Category.new(category_params)
       respond_to do |format|
         if @category.save
           #Role.create(name: @category.name, resource: @category)
           format.html { redirect_to admin_expense_report_category_path(@category), notice: 'Categoría fue creada con éxito.' }
           format.json { render :show, status: :created, location: @category }
           format.js
         else
           format.html { render :new }
           format.json { render json: @category.errors, status: :unprocessable_entity }
           format.js
         end
       end
    end

    def update
       respond_to do |format|
         if @category.update(category_params)
           format.html { redirect_to admin_expense_report_category_path(@category), notice: 'Categoría fue actualizada con éxito.' }
           format.json { render :show, status: :ok, location: @category }
         else
           format.html { render :edit }
           format.json { render json: @category.errors, status: :unprocessable_entity }
         end
       end
    end

    def destroy
       respond_to do |format|
         if @category.destroy
           format.html { redirect_to admin_expense_report_categories_path, notice: 'Categoría fue eliminada con éxito.' }
         else
           format.html { redirect_to admin_expense_report_categories_path, notice: 'Algo salió mal' }
           format.json { render json: @category.errors, status: :unprocessable_entity }
         end
       end
    end


    private

    def set_category
      @category = ExpenseReport::Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(
        :name, 
        :slug, 
        :image,
        subcategories_attributes: [:id, :name, :_destroy]
      )
    end
  end
end
