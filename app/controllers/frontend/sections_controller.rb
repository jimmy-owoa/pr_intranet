module Frontend
  class SectionsController < FrontendController
    def index
      sections = General::Section.all
      data = []
      last_know_us_post = News::Post.where(post_type: "Conociéndonos").published_posts.first
      sections.each do |section|
        if section.position == 1
          data << {
            id: last_know_us_post.id,
            title: section.title.upcase,
            description: ActionController::Base.helpers.strip_tags(last_know_us_post.content[0..368]) + "...",
            position: section.position,
            image: last_know_us_post.main_image.present? ? url_for(last_know_us_post.main_image.attachment.variant(resize: "800x800>")) : root_url + ActionController::Base.helpers.asset_url("news.jpg"),
            url: last_know_us_post.slug,
          }
        else
          data << {
            id: section.id,
            title: section.title.upcase,
            description: section.description[0..368],
            position: section.position,
            url: section.url,
            image: section.image.attached? ? url_for(section.image.attachment.variant(resize: "800x800>")) : root_url + ActionController::Base.helpers.asset_url("news.jpg"),
          }
        end
      end
      respond_to do |format|
        format.html
        format.json { render json: data }
        format.js
      end
    end
  end
end
