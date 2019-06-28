module Frontend
  class GalleriesController < FrontendController
    include Rails.application.routes.url_helpers

    def index
      user_id = params[:user_id]
      posts = News::Post.includes(:gallery).filter_posts(user_id).select {|post| post.gallery != nil}
      galleries = []
      galleries = load_galleries posts, galleries
      data = []
      galleries.each do |gal|
        attachments = []
        if gal.attachments.present? && gal.attachments.first.attachment.attached?           
          main_image = gal.attachments.first.attachment.variant(combine_options: {resize: 'x351', gravity: 'Center'})
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

    private

    def load_galleries posts, galleries, offset = 0
      galleries += General::Gallery.where(post_id: posts.pluck(:id)).offset(offset).limit(9 - offset)
      offset += galleries.count
      if galleries.count <= 9
        load_galleries posts, galleries, offset
      else
        return galleries
      end
    end
  end
end