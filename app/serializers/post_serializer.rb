class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :published_at, :content, :post_type, :important, :slug, :main_image, :accept_interactions
  attribute :breadcrumbs, if: -> { is_show? }
  attribute :relationed_posts, if: -> { is_show? }
  attribute :interactions, if: -> { is_show? }
  attribute :interaction_id, if: -> { is_show? }
  attribute :interaction_type, if: -> { is_show? }

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

  def interactions
    object.get_interactions
  end

  def interaction_id
    object.interactions.find_by(user_id: instance_options[:user_id]).try(:id)
  end

  def interaction_type
    object.interactions.find_by(user_id: instance_options[:user_id]).try(:interaction_type)
  end

  def is_show?
    instance_options[:show_action].present? ? true : false
  end
end
