class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :last_name, :image, :color, :company

  def image
    object.get_image
  end

  def color
    object.get_color
  end

  def company
    object.company.name
  end
end