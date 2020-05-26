module Api::V1
  class UserMessagesController < FrontendController
    include ApplicationHelper
    skip_before_action :verify_authenticity_token

    def index
      user_messages = @request_user.get_messages
      messages = []
      user_messages.each do |um|
        if !um.viewed_at
          content = fix_content(um.message.content)
          messages << {
            id: um.id,
            title: um.message.title,
            message_type: um.message.message_type,
            content: content,
            viewed_at: um.viewed_at,
            image: um.message.image.attached? ? url_for(um.message.image) : "",
          }
        end
      end
      respond_to do |format|
        format.json { render json: messages }
      end
    end

    def update
      user_message = @request_user.user_messages.find(params[:message_id]).update(viewed_at: Time.now)
      respond_to do |format|
        format.json { head :ok }
      end
    end
  end
end
