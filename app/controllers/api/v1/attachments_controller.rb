module Api::V1
  class AttachmentsController < ApiController
    def index
      @attachments = Media::Attachment.all
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @attachment = Media::Attachment.find(params[:id])
    end
  end
end
