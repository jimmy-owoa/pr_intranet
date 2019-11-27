module Frontend
  class BooksController < FrontendController
    before_action :set_book, only: [:show, :destroy, :edit, :update]

    def index
      page = params[:page]
      category = params[:category]
      if category == "todos"
        books = Library::Book.all
      else
        books = Library::Book.where(category: category)
      end
      books = books.page(page).per(6)
      data = []
      items = []
      books.each do |book|
        data << {
          id: book.id,
          title: book.title,
          edition: book.edition,
          publication_year: book.publication_year
          stock: book.stock,
          rating: book.rating,
          author: book.author.name,
          editorial: book.editorial.name,
          category: book.category,
          url: root_url + "admin/books/" + "#{book.id}" + "/edit",
          description: book.description,
          image: url_for(book.image),
          breadcrumbs: [
            { link: "/", name: "Inicio" },
            { link: "/biblioteca", name: "Biblioteca" },
            { link: "#", name: book.title.truncate(30) },
          ],
        }
      end
      respond_to do |format|
        format.json { render json: { hits: data } }
        format.js
      end
    end

    def book
      id = params[:id].present? ? params[:id] : nil
      book = Library::Book.find(id)
      data = []
      data << {
        id: book.id,
        title: book.title,
        edition: book.edition,
        publication_year: book.publication_year
        stock: book.stock,
        rating: book.rating,
        author: book.author.name,
        editorial: book.editorial.name,
        category: book.category,
        url: root_url + "admin/books/" + "#{book.id}" + "/edit",
        description: book.description,
        image: url_for(book.image),
        breadcrumbs: [
          { link: "/", name: "Inicio" },
          { link: "/biblioteca", name: "Biblioteca" },
          { link: "#", name: book.title.truncate(30) },
        ],
      }
      respond_to do |format|
        format.json { render json: data }
        format.js
      end
    end

    private

    def set_book
      @book = Library::Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:id)
    end
  end
end
