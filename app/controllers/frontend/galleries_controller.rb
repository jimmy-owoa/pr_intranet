module Frontend
  class GalleriesController < FrontendController
    include Rails.application.routes.url_helpers

    def index    
      galleries = General::Gallery.all.joins(:attachments).uniq.last(9)
      data = []
      galleries.each do |gal|
        attachments = []
        main_image = gal.attachments.first.attachment.variant(combine_options: {resize: 'x351', gravity: 'Center'})
        data << {
          id: gal.id,
          name: gal.name,
          publish_date: gal.created_at.strftime("%d-%m-%Y"),
          main_image: url_for(main_image),
          post_slug: gal.post.present? ? gal.post.slug : nil
        }
      end
      
      respond_to do |format|
        format.json { render json: data }
        format.js
      end    
    end
  end
end