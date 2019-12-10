module Admin
	class BooksController < AdminController
		before_action :set_book, only: [:show, :edit, :update, :destroy]

		def index
			page = params[:page]
			@books = Library::Book.all.page(page).per(10)
		end

		def show
		end

		def new
			@book = Library::Book.new
		end

		def create
			@book = Library::Book.new(book_params)
			set_book_atributes

			respond_to do |format|
				if @book.save
          format.html { redirect_to admin_book_path(@book), notice: "Libro fue creado con éxito." }
          format.json { render :show, status: :created, location: @book }
        else
          format.html { render :new }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
		end

		def edit
		end

		def update
			respond_to do |format|
				if @book.update(book_params)
					set_book_atributes
          format.html { redirect_to admin_book_path(@book), notice: "Libro fue actualizado con éxito." }
          format.json { render :show, status: :ok, location: @book }
        else
          format.html { render :edit }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
		end
		
		def destroy
      @book.destroy
      respond_to do |format|
        format.html { redirect_to admin_books_path, notice: "Libro fue eliminado con éxito." }
        format.json { head :no_content }
      end
		end

		private

		def set_book
			@book = Library::Book.find(params[:id])
		end

		def set_book_atributes
			category = Library::CategoryBook.where(name: params[:book][:category_book_id]).first_or_create.id
			author = Library::Author.where(name: params[:book][:author_id]).first_or_create.id
			editorial = Library::Editorial.where(name: params[:book][:editorial_id]).first_or_create.id
			@book.update(category_book_id: category, author_id: author, editorial_id: editorial)
		end

		def book_params
			params.require(:book).permit(:title, :edition, :image, :description, :stock, :rating, :edition_date, :publication_year, :available)
		end
	end
end
