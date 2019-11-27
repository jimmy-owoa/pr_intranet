module Admin
  class EditorialsController < AdminController
    before_action :set_editorial, only: [:show, :edit, :update, :destroy]

    def index
			page = params[:page]
			@editorials = Library::Editorial.all.page(page).per(10)
    end

    def show
      page = params[:page]
      @books = Library::Book.all.where(editorial_id: @editorial).page(page).per(10)
		end

		def new
			@editorial = Library::Editorial.new
		end

		def create
			@editorial = Library::Editorial.new(editorial_params)
      respond_to do |format|
				if @editorial.save
          format.html { redirect_to admin_editorial_path(@editorial), notice: "Editorial fue creado con éxito." }
          format.json { render :show, status: :created, location: @editorial }
        else
          format.html { render :new }
          format.json { render json: @editorial.errors, status: :unprocessable_entity }
        end
      end
		end

		def edit
		end

		def update
      respond_to do |format|
        if @editorial.update(editorial_params)
          format.html { redirect_to admin_editorial_path(@editorial), notice: "Editorial fue actualizado con éxito." }
          format.json { render :show, status: :ok, location: @editorial }
        else
          format.html { render :edit }
          format.json { render json: @editorial.errors, status: :unprocessable_entity }
        end
      end
		end
		
		def destroy
      @editorial.destroy
      respond_to do |format|
        format.html { redirect_to admin_editorials_path, notice: "Editorial fue eliminado con éxito." }
        format.json { head :no_content }
      end
		end

		private

		def set_editorial
			@editorial = Library::Editorial.find(params[:id])
		end
		
		def editorial_params
			params.require(:editorial).permit(:name)
		end
  end
end