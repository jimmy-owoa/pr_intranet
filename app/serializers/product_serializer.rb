class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :currency, :price, :main_image

  attribute :phone, if: -> { is_show? }
  attribute :email, if: -> { is_show? }
  attribute :breadcrumbs, if: -> { is_show? }
  attribute :location, if: -> { is_show? }
  attribute :user_company, if: -> { is_show? }
  attribute :approved, if: -> { is_show? }
  attribute :user_id, if: -> { is_show? }
  attribute :is_expired, if: -> { is_show? }
  attribute :items, if: -> { is_show? }

  def main_image
    object.get_main_image
  end

  def user_company
    object.user.company.present? ? object.user.company.name : ""
  end

  def breadcrumbs
    [
      { to: "/", text: "Inicio", disabled: false, exact: true },
      { to: "/avisos-clasificados", text: "Avisos clasificados", disabled: false, exact: true },
      { to: "", text: object.name.truncate(30), disabled: true },
    ]
  end

  def items
    object.get_images
  end

  def is_show?
    instance_options[:is_show]
  end
end
