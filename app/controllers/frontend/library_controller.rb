module Frontend
  class LibraryController < FrontendController
    skip_before_action :verify_authenticity_token, only: [:create_request_book]

    def index
      page = params[:page]
      category = params[:category]

      if category.present? && category != "Todos"
        books = Library::Book.available_books.joins(:category_book).where("library_category_books.name = ?", category)
      else
        books = Library::Book.available_books
      end

      books = books.page(page).per(6)
      data = []
      items = []
      books.each do |book|
        data << {
          id: book.id,
          title: book.title,
          edition: book.edition,
          publication_year: book.publication_year,
          stock: book.stock,
          rating: book.rating,
          author: book.author.name,
          editorial: book.editorial,
          category: book.category_book.name,
          url: root_url + "admin/books/" + "#{book.id}" + "/edit",
          description: book.description,
          image: book.image.attached? ? url_for(book.image) : "",
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

    def show
      id = params[:id].present? ? params[:id] : nil
      book = Library::Book.find(id)
      data = []
      data << {
        id: book.id,
        title: book.title,
        edition: book.edition,
        publication_year: book.publication_year,
        stock: book.stock,
        rating: book.rating,
        author: book.author.name,
        editorial: book.editorial,
        category: book.category_book.name,
        url: root_url + "admin/books/" + "#{book.id}" + "/edit",
        description: book.description,
        image: url_for(book.image),
        breadcrumbs: [
          { href: "/", text: "Inicio" },
          { href: "/biblioteca", text: "Biblioteca" },
          { href: "#", text: book.title.truncate(19), disabled: true },
        ],
      }
      respond_to do |format|
        format.json { render json: data[0] }
        format.js
      end
    end

    def create_request_book
      user_id = @request_user.id
      book_id = params[:book_id]

      @request_book = General::UserBookRelationship.new(user_id: user_id, book_id: book_id, request_date: Date.today, expiration: 30)

      if @request_book.save
        render json: @request_book, status: 200
      else
        render json: @request_book.errors, status: :unprocessable_entity
      end
    end

    def get_categories
      categories = Library::CategoryBook.all
      data = ["Todos"]
      categories.each do |category|
        if category.books.available_books.present?
          data << category.name
        end
      end

      render json: data, status: 200
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
