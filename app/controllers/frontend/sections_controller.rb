module Frontend
  class SectionsController < FrontendController
    def index
      sections = General::Section.all
      data = []
      last_know_us_post = News::Post.where(post_type: "Conociéndonos").published_posts.first
      data_products = []
      Marketplace::Product.show_product.last(20).each do |product|
        data_products << {
          id: product.id,
          name: product.name,
          price: product.price.to_i,
          image: product.images.first.present? ? url_for(product.images.first.variant(combine_options: {resize: '440x', gravity: 'Center'})) : root_url + '/assets/noimage.png'
        }
      end
      sections.each do |section|
        if section.position == 1
          data << {
            id: last_know_us_post.id,
            title: section.title.upcase,
            description: ActionController::Base.helpers.strip_tags(last_know_us_post.content[0..368]) + "...",
            position: section.position,
            image: last_know_us_post.main_image.present? ? url_for(last_know_us_post.main_image.attachment.variant(resize: '800x800>')) : root_url + '/assets/news.jpg',
            url: last_know_us_post.slug
          }
        elsif section.position == 3
          data << {
            id: section.id,
            title: section.title.upcase,
            products: data_products,
            position: section.position,
            url: section.url
          }

        else
          data << {
            id: section.id,
            title: section.title.upcase,
            description: section.description[0..368],
            position: section.position,
            url: section.url
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