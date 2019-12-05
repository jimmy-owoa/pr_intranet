module Admin
  class UserBookRelationshipsController < AdminController
    before_action :set_user_book, only: [:show, :destroy]

    def index
      page = params[:page]
      @requested_books = General::UserBookRelationship.all.page(page).per(10)
    end

    def show
    end

    def destroy
      @user_book.destroy
      respond_to do |format|
        format.html { redirect_to admin_user_book_relationships_path, notice: "Solicitud fue eliminada con éxito." }
        format.json { head :no_content }
      end
		end

    private

    def set_user_book
			@user_book = General::UserBookRelationship.find(params[:id])
		end

  end
end
