class LinkSerializer < ActiveModel::Serializer
  attributes :id, :title, :is_blank, :url, :image

  def image
    object.get_image
  end
end
