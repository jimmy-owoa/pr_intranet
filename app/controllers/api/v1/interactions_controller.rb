module Api::V1
  class InteractionsController < ApiController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    skip_before_action :verify_authenticity_token
    before_action :set_post
    before_action :set_interaction, only: [:destroy]

    def create
      if @post.liked?(@request_user)
        interaction = @post.interactions.find_by(user: @request_user)
        interaction.interaction_type = interaction_params[:interaction_type]
      else
        interaction = @post.interactions.build(interaction_params)
        interaction.user = @request_user
      end

      if interaction.save
        render json: { id: interaction.id, success: true, msg: 'Interaction created success'}, status: :created
      else
        render json: { success: false, msg: 'Error' }, status: :unprocessable_entity
      end
    end

    def destroy
      if !@post.liked?(@request_user)
        return render json: { success: false, msg: 'Can not delete'}, status: :bad_request
      end

      if @interaction.destroy
        render json: { success: true, msg: 'deleted success'}, status: :ok
      else
        render json: { success: false, msg: 'Error' }, status: :unprocessable_entity
      end
    end

    private

    def set_interaction
      @interaction = News::Interaction.find(params[:id])
    end

    def set_post
      @post = News::Post.find(params[:post_id])
    end

    def interaction_params
      params.permit(:interaction_type)
    end

    def record_not_found
      render json: { msg: "Error" }, status: :not_found
    end
  end
end