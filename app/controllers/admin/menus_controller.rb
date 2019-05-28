module Admin 
  class MenusController < AdminController
    before_action :set_menu, only:[:show, :edit, :update, :destroy]

    def index
      @menus = General::Menu.paginate(:page => params[:page], :per_page => 10)
    end

    def new
      @menu = General::Menu.new
    end

    def html 
      @user_id = 3 # TODO: Cambiar al correcto
      @location_id = 2 # TODO: Cambiar al correcto
      @menus = General::Menu.all
      @user = General::User.find(@user_id)
      @weather = General::WeatherInformation.current(@location_id)
      @location = General::Location.find(@location_id) 
      @santoral = General::Santoral.current
      @location_name = @location.name
      if @user.legal_number.present?
        exa_menu_url = URI.parse("https://misecurity-qa2.exa.cl/json_menus/show/#{@user.legal_number}")
        exa_menu_response = Net::HTTP.get_response exa_menu_url
        exa_menu = JSON.parse(exa_menu_response.body)
      else
        exa_menu = ""
      end
      @data = {
        menus: @menus,
        user: @user,
        weather: @weather,
        santoral: @santoral[0],
        location_name: @location.name,
        exa_menu: exa_menu
      }
      respond_to do |format|
        format.json { render @data }
      end
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
      params.require(:menu).permit(:title, :description, :css_class, :code, :priority, :parent_id, :link, :integration_code, term_ids: [])
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