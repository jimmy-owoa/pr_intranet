module Api::V1
  class CommentsController < ApiController
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    skip_before_action :verify_authenticity_token
    before_action :set_post
    before_action :set_comment, only: [:destroy]


    def index
      data = []
      page = params[:page] || 1
      comments = @post.comments.order(id: :desc).page(page).per(10)
      
      comments.each do |comment|
        data << {
          id: comment.id,
          content: comment.content,
          user: comment.user.full_name,
          user_id: comment.user_id,
          avatar: comment.user.get_image,
          created_at: comment.created_at.strftime('%d-%m-%Y %H:%M')
        }
      end
      
      render json: { comments: data, total: comments.total_count }, status: :ok
    end

    def create
      comment = @post.comments.build(comments_params)
      comment.user = @request_user
      
      if comment.save
        render json: { msg: 'Comment created success'}, status: :created
      else
        render json: { msg: 'Error' }, status: :unprocessable_entity
      end
    end

    def destroy
      if @comment.user_id != @request_user.id && !@request_user.is_admin?
        return render json: { success: false, msg: 'can not deleted' }, status: :bad_request
      end
      
      if @comment.destroy
        render json: { success: true, msg: 'Comment deleted' }, status: :ok
      else
        render json: { msg: 'Error' }, status: :unprocessable_entity
      end
    end

    private

    def parameter_missing
      render json: { msg: "Error" }, status: :bad_request
    end

    def record_not_found
      render json: { msg: "Error" }, status: :not_found
    end

    def set_comment
      @comment = News::Comment.find(params[:id])
    end

    def set_post
      @post = News::Post.find(params[:post_id])
    end

    def comments_params
      params.require(:comment).permit(:content, :post_id)
    end
  end
end
