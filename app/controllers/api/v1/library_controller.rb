module Api::V1
  class LibraryController < ApiController
    skip_before_action :verify_authenticity_token, only: [:create_request_book]

    def index
      page = params[:page]
      category = params[:category]
      if category.present? && page.present?
        if category != "Todos"
          books = Library::Book.available_books.joins(:category_book).where("library_category_books.name = ?", category)
        else
          books = Library::Book.available_books
        end

        books = books.page(page).per(6)
        data_books = []
        items = []
        books.each do |book|
          data_books << {
            id: book.id,
            title: book.title,
            edition: book.edition,
            publication_year: book.publication_year,
            stock: book.stock,
            rating: book.rating,
            author: book.author.name,
            editorial: book.editorial,
            category: book.category_book.name,
            # url: root_url + "admin/books/" + "#{book.id}" + "/edit",
            description: book.description,
            image: book.image.attached? ? url_for(book.image) : "",
            breadcrumbs: [
              { link: "/", name: "Inicio" },
              { link: "/biblioteca", name: "Biblioteca" },
              { link: "#", name: book.title.truncate(30) },
            ],
          }
        end
        data = { status: "ok", page: page, category: category, results_length: data_books.count, books: data_books  }
        render json: data, status: :ok
      else
        render json: { status: "error", message: "bad request" }, status: :bad_request
      end
    end

    def show
      id = params[:id].present? ? params[:id] : nil
      if id.present?
        book = Library::Book.find(id)
        data_book = {
          id: book.id,
          title: book.title,
          edition: book.edition,
          publication_year: book.publication_year,
          stock: book.stock,
          rating: book.rating,
          author: book.author.name,
          editorial: book.editorial,
          category: book.category_book.name,
          # url: root_url + "admin/books/" + "#{book.id}" + "/edit",
          description: book.description,
          image: url_for(book.image),
        }
        breadcrumbs = [
          { href: "/", text: "Inicio" },
          { href: "/biblioteca", text: "Biblioteca" },
          { href: "#", text: book.title.truncate(19), disabled: true },
        ]
        data = { status: "ok", breadcrumbs: breadcrumbs, book: data_book }
        render json: data, status: :ok
      else
        render json: { status: 'error', message: 'bad request' }, status: :bad_request
      end
    end

    def create_request_book
      user_id = @request_user.id
      book_id = params[:book_id]

      @request_book = General::UserBookRelationship.new(user_id: user_id, book_id: book_id, request_date: Date.today, expiration: 30)

      if @request_book.save
        render json: { status: "ok", request_book: @request_book }, status: :created
      else
        render json: { status: "error", message: @request_book.errors }, status: :unprocessable_entity
      end
    end

    def get_categories
      categories = Library::CategoryBook.all
      data_categories = ["Todos"]
      categories.each do |category|
        if category.books.available_books.present?
          data_categories << category.name
        end
      end
      data = { status: "ok", results_length: data_categories.count, categories: data_categories }
      render json: data, status: :ok
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
