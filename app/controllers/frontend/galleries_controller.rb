module Frontend
  class GalleriesController < FrontendController
    include Rails.application.routes.url_helpers

    def index
      user_id = params[:user_id]
      posts = News::Post.filter_posts(user_id).select {|post| post.gallery != nil}
      gallery_ids = posts.map(&:gallery).map(&:id)
      galleries = General::Gallery.find(gallery_ids).first(9)
      data = []
      galleries.each do |gal|
        attachments = []
        if gal.attachments.present?           
          main_image = gal.attachments.first.present? ? gal.attachments.first.attachment.
          variant(combine_options: {resize: 'x351', gravity: 'Center'}) : root_url + '/assets/noimage.png'
          data << {
            id: gal.id,
            name: gal.name,
            publish_date: gal.created_at.strftime("%d-%m-%Y"),
            main_image: url_for(main_image),
            post_slug: gal.post.present? ? gal.post.slug : nil
          }
        end
      end
      respond_to do |format|
        format.json { render json: data }
        format.js
      end
    end
  end
end