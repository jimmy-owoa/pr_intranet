module Api::V1
  class GalleriesController < ApiController
    include Rails.application.routes.url_helpers

    def index
      posts = News::Post.includes(:gallery).filter_posts(@request_user).select { |post| post.gallery.present? }
      galleries = []
      offset = 0
      galleries = load_galleries posts.pluck(:id), galleries, offset
      data_galleries = []
      galleries.each do |gal|
        attachments = []
        if gal.attachments.present? && gal.attachments.first.attachment.attached?
          main_image = gal.attachments.first.attachment.variant(combine_options: { resize: "x351", gravity: "Center" })
          data_galleries << {
            id: gal.id,
            name: gal.name,
            publish_date: gal.created_at.strftime("%d-%m-%Y"),
            main_image: url_for(main_image),
            post_slug: gal.post.present? ? gal.post.slug : nil,
          }
        end
      end
      data = { status: 'ok', results_length: data_galleries.count, galleries: data_galleries }
      render json: data, status: :ok
    end

    private

    def load_galleries(post_ids, galleries, offset)
      return galleries if offset > 10
      galleries += Media::Gallery.order(created_at: :desc).where(post_id: post_ids).offset(offset).limit(1)
      if galleries.count <= 10
        offset += 1
        return load_galleries(post_ids, galleries, offset)
      else
        return galleries
      end
    end
  end
end
