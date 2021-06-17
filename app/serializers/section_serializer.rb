class SectionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :position, :url, :image

  def image
    object.get_image
  end
end