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
			set_new_category
			set_new_author
			set_new_editorial
					
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

		def set_new_category
			category_selected = params[:book][:category_book_id]
			category = Library::CategoryBook.where(id: category_selected)
			
			if category.empty?
				@category = Library::CategoryBook.create(name: category_selected)
				@book.category_book_id = @category.id
			end
		end

		def set_new_author
			author_selected = params[:book][:author_id]
			author = Library::Author.where(id: author_selected)
			
			if author.empty?
				@author = Library::Author.create(name: author_selected)
				@book.author_id = @author.id
			end
		end

		def set_new_editorial
			editorial_selected = params[:book][:editorial_id]
			editorial = Library::Editorial.where(id: editorial_selected)
			
			if editorial.empty?
				@editorial = Library::Editorial.create(name: editorial_selected)
				@book.editorial_id = @editorial.id
			end
		end

		def book_params
			params.require(:book).permit(:title, :edition, :image, :description, :stock, :rating, :category_book_id, :edition_date, :publication_year, :author_id, :editorial_id, :available)
		end
	end
end
