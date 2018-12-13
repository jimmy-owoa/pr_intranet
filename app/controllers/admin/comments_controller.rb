module Admin
  class CommentsController < ApplicationController
    before_action :set_comment, only: [:show, :edit, :update, :destroy]

    def index
      @comments = News::Comment.all
    end

    def show
    end

    def new
      @comment = News::Comment.new
    end

    def edit
    end

    def create
      @comment = News::Comment.new(comment_params)
      respond_to do |format|
        if @comment.save
          format.html { redirect_to edit_admin_comment_path(@comment), notice: 'Comment was successfully created.'}
          format.json { render :show, status: :created, location: @comment}
        else
          format.html { render :new}
          format.json { render json: @comment.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      respond_to do |format|
        if @comment.update(comment_params)
          format.html { redirect_to admin_comment_path(@comment), notice: 'Comment was successfully updated.'}
          format.json { render :show, status: :ok, location: @comment }
        else
          format.html { render :edit}
          format.json { render json: @comment.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to admin_comments_path, notice: 'Comment was successfully destroyed.'}
        format.json { head :no_content }
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = News::Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:user_ip, :content, :approved, :post_id)
    end
  end
end
