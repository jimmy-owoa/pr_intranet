class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :last_name, :image, :color, :company

  attribute :full_name, if: -> { is_welcome_index? }
  attribute :date_entry, if: -> { is_welcome_index? }

  def image
    object.get_image
  end

  def full_name
    object.get_full_name
  end

  def date_entry
    I18n.l(object.date_entry, format: "%d de %B").downcase
  end

  def color
    object.get_color
  end

  def company
    object.company.try(:name)
  end

  def is_welcome_index?
    instance_options[:is_welcome_index]
  end
end