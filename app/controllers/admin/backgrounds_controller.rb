module Admin
  class BackgroundsController < AdminController
    before_action :set_background, only: [:show, :edit, :update, :destroy]

    def index
      page = params[:page]
      @backgrounds = General::Background.all.page(page).per(10)
    end

    def show
    end

    def new
      @background = General::Background.new
    end

    def create
      @background = General::Background.new(background_params)
      respond_to do |format|
        if @background.save
          format.html { redirect_to admin_background_path(@background), notice: "Fondo fue creado con éxito." }
          format.json { render :show, status: :created, location: @background }
        else
          format.html { render :new }
          format.json { render json: @background.errors, status: :unprocessable_entity }
        end
      end
    end

    def edit
    end

    def update
      respond_to do |format|
        if @background.update(background_params)
          format.html { redirect_to admin_background_path(@background), notice: "Fondo fue actualizado con éxito." }
          format.json { render :show, status: :ok, location: @background }
        else
          format.html { render :edit }
          format.json { render json: @background.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @background.destroy
      respond_to do |format|
        format.html { redirect_to admin_backgrounds_path, notice: "Fondo fue eliminado con éxito." }
        format.json { head :no_content }
      end
    end

    private

    def set_background
      @background = General::Background.find(params[:id])
    end

    def background_params
      params.require(:background).permit(:name, :starts, :ends, :image)
    end
  end
end
