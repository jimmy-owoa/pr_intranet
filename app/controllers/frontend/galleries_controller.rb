module Frontend
  class GalleriesController < FrontendController
    include Rails.application.routes.url_helpers

    def index
      ln_user = params[:ln_user]
      posts = News::Post.includes(:gallery).filter_posts(ln_user).select {|post| post.gallery.present?}
      galleries = []
      offset = 0
      galleries = load_galleries posts.pluck(:id), galleries, offset
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

    def load_galleries post_ids, galleries, offset
      return galleries if offset > 9
      galleries += General::Gallery.order(created_at: :desc).where(post_id: post_ids).offset(offset).limit(1)
      if galleries.count <= 9
        offset += 1
        return load_galleries(post_ids, galleries, offset)
      else
        return galleries
      end
    end
  end
end