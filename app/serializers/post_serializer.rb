class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :published_at, :content, :post_type, :important, :slug, :main_image
  attribute :breadcrumbs, if: -> { is_show? }
  attribute :relationed_posts, if: -> { is_show? }

  def main_image
    object.get_main_image
  end

  def published_at
    if is_show?
      object.get_show_published_at
    else
      object.published_at.strftime("%d/%m/%Y")
    end
  end

  def breadcrumbs
    [
      { to: "/", text: "Inicio", disabled: false, exact: true },
      { to: "/noticias", text: "Noticias", disabled: false, exact: true },
      { to: "", text: object.title.truncate(30), disabled: true },
    ]
  end

  def relationed_posts
    object.get_relationed_posts(@request_user).map do |post|
      {
        id: post.id,
        title: post.title.truncate(30),
        slug: post.slug,
        published_at: post.published_at.strftime("%d/%m/%Y"),
        main_image: post.get_main_image
      }
    end
  end

  def is_show?
    instance_options[:show_action].present? ? true : false
  end
end
