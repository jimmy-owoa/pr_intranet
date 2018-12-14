module Frontend
  class AttachmentsController < ApplicationController
    after_action :set_tracking, only: [:index, :show]

    def index
      @attachments = General::Attachment.all
    end

    private
    def set_tracking
      ahoy.track "Attachment Model", params
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @attachment = General::Attachment.find(params[:id])
    end

  end
end