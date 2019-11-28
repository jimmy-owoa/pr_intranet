module Admin
  class Admin::AuthorsController < AdminController
    before_action :set_author, only: [:show, :edit, :update, :destroy]

    def index
			page = params[:page]
			@authors = Library::Author.all.page(page).per(10)
    end

    def show
      page = params[:page]
      @books = Library::Book.all.where(author_id: @author).page(page).per(10)
		end

		def new
			@author = Library::Author.new
		end

		def create
			@author = Library::Author.new(author_params)
      respond_to do |format|
				if @author.save
          format.html { redirect_to admin_author_path(@author), notice: "Author fue creado con éxito." }
          format.json { render :show, status: :created, location: @author }
        else
          format.html { render :new }
          format.json { render json: @author.errors, status: :unprocessable_entity }
        end
      end
		end

		def edit
		end

		def update
      respond_to do |format|
        if @author.update(author_params)
          format.html { redirect_to admin_author_path(@author), notice: "Autor fue actualizado con éxito." }
          format.json { render :show, status: :ok, location: @author }
        else
          format.html { render :edit }
          format.json { render json: @author.errors, status: :unprocessable_entity }
        end
      end
		end
		
		def destroy
      @author.destroy
      respond_to do |format|
        format.html { redirect_to admin_authors_path, notice: "Autor fue eliminado con éxito." }
        format.json { head :no_content }
      end
		end

		private

		def set_author
			@author = Library::Author.find(params[:id])
		end
		
		def author_params
			params.require(:author).permit(:name)
		end
  end
end
