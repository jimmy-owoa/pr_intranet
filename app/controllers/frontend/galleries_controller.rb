module Frontend
  class GalleriesController < FrontendController
    include Rails.application.routes.url_helpers

    def index    
      galleries = General::Gallery.all.joins(:attachments).uniq.last(9)
      data = []
      galleries.each do |gal|
        attachments = []
        gal.attachments.each do |att|
          if att.attachment.metadata.dig("width").to_i < 351
            attachments << {
              img: url_for(att.attachment.variant(combine_options: {resize: 'x351', gravity: 'Center'})),
              caption: att.caption.present? ? att.caption : ''
            }
          else
            attachments << {
              img: url_for(att.attachment.variant(combine_options: {resize: 'x351>', gravity: 'Center'})),
              caption: att.caption.present? ? att.caption : ''
            }
          end
        end
        data << {
          id: gal.id,
          name: gal.name,
          publish_date: gal.created_at.strftime("%d-%m-%Y"),
          main_image: url_for(gal.attachments.first.attachment.variant(combine_options: {resize: 'x351', gravity: 'Center'})),
          images: attachments,
        }
      end
      
      respond_to do |format|
        format.json { render json: data }
        format.js
      end    
    end
  end
end