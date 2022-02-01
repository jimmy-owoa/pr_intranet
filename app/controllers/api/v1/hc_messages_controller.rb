module Api::V1
  class HcMessagesController < ApiController
    skip_before_action :verify_authenticity_token
    before_action :set_ticket

    def create
      message = @ticket.chat_messages.build(message_params)
      message.user = @request_user

      if message.save
        UserNotifierMailer.notification_new_message_user(@ticket, message.content).deliver if @ticket.assistant.present?
        render json: { message: "Message created", success: true }, status: :created
      else
        render json: { message: "Error", success: false }, status: :unprocessable_entity
      end
    end

    private

    def message_params
      params.require(:message).permit(:content)
    end

    def set_ticket
      @ticket = Helpcenter::Ticket.find(params[:hc_ticket_id])
    end
  end
end
