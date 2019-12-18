module Frontend
  class AttachmentsController < FrontendController
    def index
      @attachments = General::Attachment.all
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @attachment = General::Attachment.find(params[:id])
    end
  end
end
