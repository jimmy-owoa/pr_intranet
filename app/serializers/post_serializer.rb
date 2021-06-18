class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :published_at, :content, :post_type, :important, :slug, :main_image
  attribute :breadcrumbs, if: -> { is_show? }

  def main_image
    object.get_main_image
  end

  def published_at
    object.published_at.strftime("%d/%m/%Y")
  end

  def breadcrumbs
    [
      { to: "/", text: "Inicio" },
      { to: "/noticias", text: "Noticias" },
      { to: "", text: object.title.truncate(30) },
    ]
  end

  def is_show?
    instance_options[:show]
  end
end
