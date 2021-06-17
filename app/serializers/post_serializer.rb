class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :published_at, :content, :post_type, :important, :slug, :main_image

  def main_image
    object.get_main_image
  end
end
