module Frontend
  class GalleriesController < FrontendController
    include Rails.application.routes.url_helpers

    def index    
      galleries = General::Gallery.all.joins(:attachments).uniq.last(3)
      data = []
      galleries.each do |gal|
        attachments = []
        gal.attachments.each do |att|
          attachments << {
            img: url_for(att.attachment)
          }
        end
        data << {
          id: gal.id,
          name: gal.name,
          main_image: url_for(gal.attachments.first.attachment),
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