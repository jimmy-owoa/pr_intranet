class LinkSerializer < ActiveModel::Serializer
  attributes :id, :title, :is_blank, :url, :image, :is_left

  def image
    object.get_image
  end
end
