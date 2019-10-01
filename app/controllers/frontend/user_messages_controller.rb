module Frontend
  class UserMessagesController < FrontendController
    def index
      user_messages = General::User.get_user_by_ln(params[:ln_user]).user_messages
      messages = []
      user_messages.each do |um|
        if !um.viewed_at
          messages << {
            id: um.id,
            title: um.message.title,
            message_type: um.message.message_type,
            content: um.message.content,
            viewed_at: um.viewed_at,
            image: um.message.image.attached? ? url_for(um.message.image) : '',
          }
        end
      end
      respond_to do |format|
        format.json { render json: messages }
      end
    end

    def update
      user_message = General::User.get_user_by_ln(params[:ln_user]).user_messages.find(params[:message_id]).update(viewed_at: Time.now)
      respond_to do |format|
        format.json { head :ok }
      end
    end
  end
end
