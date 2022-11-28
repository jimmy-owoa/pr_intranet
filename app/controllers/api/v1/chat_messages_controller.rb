module Api::V1
  class ChatMessagesController < ApiController
    skip_before_action :set_current_user_from_header, only: [:review_request, :response_request]
    skip_before_action :verify_authenticity_token
    def create
      messages = Chat::Room.where(resource_id: params[:request_id] , resource_type: 'ExpenseReport::Request').last.messages
      if messages.create(message_params)
        render json: { message: "Message created", success: true }, status: :ok
      else
        render json: { message: "Error", success: false }, status: :unprocessable_entity
      end
    end

    private 

    def message_params
      params.require(:message).permit(:message, :user_id, files: [])
    end

  end
end
  