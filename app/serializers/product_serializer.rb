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
  attribute :user_full_name, if: -> { is_show? }
  attribute :description, if: -> { is_show? }

  attribute :product_type, if: -> { is_show? }
  attribute :images, if: -> { is_show? }

  def main_image
    object.get_main_image(is_user_product?)
  end

  def images
    return []
  end

  def user_company
    object.user.company.present? ? object.user.company.name : ""
  end

  def user_full_name
    object.user.get_full_name
  end

  def breadcrumbs
    if is_user_product?
      [
        { to: "/", text: "Inicio", disabled: false, exact: true },
        { to: "/avisos-clasificados", text: "Avisos clasificados", disabled: false, exact: true },
        { to: "/avisos-clasificados/mis-avisos", text: "Mis avisos", disabled: false, exact: true },
        { to: "", text: object.name.truncate(30), disabled: true },
      ]
    else
      [
        { to: "/", text: "Inicio", disabled: false, exact: true },
        { to: "/avisos-clasificados", text: "Avisos clasificados", disabled: false, exact: true },
        { to: "", text: object.name.truncate(30), disabled: true },
      ]
    end
  end

  def items
    object.get_images(is_user_product?)
  end

  def is_show?
    instance_options[:is_show]
  end

  def is_user_product?
    instance_options[:is_user_product].present? ? instance_options[:is_user_product] : false
  end
end
