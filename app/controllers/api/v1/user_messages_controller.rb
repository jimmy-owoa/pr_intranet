module Api::V1
  class UserMessagesController < ApiController
    include ApplicationHelper
    skip_before_action :verify_authenticity_token

    def index
      user_messages = @request_user.get_messages
      data_messages = []
      user_messages.each do |um|
        if !um.viewed_at
          content = fix_content(um.message.content)
          data_messages << {
            id: um.id,
            title: um.message.title,
            message_type: um.message.message_type,
            content: content,
            viewed_at: um.viewed_at,
            image: um.message.image.attached? ? url_for(um.message.image) : "",
          }
        end
      end
      data = { status: "ok", results_length: data_messages.count, messages: data_messages }
      render json: data, status: :ok
    end

    def update
      message_id = params[:message_id]
      if message_id.present?
        user_message = @request_user.user_messages.find(message_id).update(viewed_at: Time.now)
        render json: { status: "ok", message: "updated"}
      else
        render json: { status: "error", message: "bad request" }, status: :bad_request
      end
    end
  end
end
