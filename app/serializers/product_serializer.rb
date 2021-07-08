class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :currency, :price, :main_image

  def main_image
    object.get_main_image
  end
end
