module Api::V1
  class SectionsController < ApiController
    def index
      sections = General::Section.all
      data_sections = []
      last_know_us_post = News::Post.where(post_type: "Conociéndonos").published_posts.first
      sections.each do |section|
        if section.position == 1
          data_sections << {
            id: last_know_us_post.id,
            title: last_know_us_post.title,
            description: ActionController::Base.helpers.strip_tags(last_know_us_post.content[0..368]) + "...",
            position: section.position,
            image: last_know_us_post.main_image.present? ? url_for(last_know_us_post.main_image.attachment.variant(resize: "800x")) : ActionController::Base.helpers.asset_path("news.jpg"),
            url: last_know_us_post.slug,
          }
        else
          data_sections << {
            id: section.id,
            title: section.title.upcase,
            description: section.description[0..368],
            position: section.position,
            url: section.url,
            image: section.image.attached? ? url_for(section.image.attachment.variant(resize: "800x")) : ActionController::Base.helpers.asset_path("news.jpg"),
          }
        end
      end
      data = { status: 'ok', sections: data_sections, sections_length: data_sections.count }
      render json: data, status: :ok
    end
  end
end
