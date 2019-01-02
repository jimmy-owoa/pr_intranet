module Admin 
  class MenusController < ApplicationController
    before_action :set_menu, only:[:show, :edit, :update, :destroy]
    layout 'admin'

    def index
      @menus = General::Menu.all
    end

    def new
      @menu = General::Menu.new
    end

    def create
      @menu = General::Menu.new(menu_params)
      respond_to do |format|
        if @menu.save
          set_categories
          format.html { redirect_to admin_menu_path(@menu), notice: 'menu creado con éxito.'}
          format.json { render :show, status: :created, location: @menu}
          format.js
        else
          format.html {render :new}
          format.json {render json: @menu.errors, status: :unprocessable_entity}
          format.js
        end
      end
    end

    def edit
    end

    def show
    end

    def update
      respond_to do |format|
        if @menu.update(menu_params)
          set_categories
          format.html { redirect_to admin_menu_path(@menu), notice: 'menu fue actualizado con éxito.'}
          format.json { render :show, status: :ok, location: @menu }
        else
          format.html { render :edit}
          format.json { render json: @menu.errors, status: :unprocessable_entity}
        end
      end    
    end

    def destroy
      @menu.destroy
      respond_to do |format|
        format.html { redirect_to admin_menus_path, notice: 'menu fue destruido con éxito.'}
        format.json { head :no_content }
      end    
    end

    private

    def set_menu
      @menu =  General::Menu.find(params[:id])
    end

    def menu_params
      params.require(:menu).permit(:title, :description, :css_class, :code, :priority, :parent_id, :link)
    end

    def set_categories
      # Getting terms_names from the form (tags)
      categories = params[:term_names]
      terms = []
      # If in the form the user doesnt add categories, this will do nothing
      if categories.present?
        categories.uniq.each do |category|
          # @menu.terms.find_or_create_by(name: category, term_type: General::TermType.category)
          terms << General::Term.where(name: category).first_or_create
        end
      end
      @menu.terms << terms
    end    
  end
end