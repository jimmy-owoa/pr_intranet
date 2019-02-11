module Frontend
  class MessagesController < ApplicationController
    def index
      messages = General::Message.last(6)
      data = []
      messages.each do |message|
        @image = message.image.attachment.present? ? @ip + message.image.path : nil
        data << {
          id: message.id,
          title: message.title,
          content: message.content,
          is_const: message.is_const,
          kind: message.kind,
          created_at: l(message.created_at, format: '%A %d %B %Y'),
          image: @image
        }
      end
      respond_to do |format|
        format.html
        format.json { render json: data }
        format.js
      end
    end
  end
end