class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :full_name, :last_name, :image, :color, :company

  attribute :date_entry, if: -> { is_welcome_index? }
  attribute :birthday, if: -> { is_birthday_index? }
  attribute :annexed, if: -> { is_birthday_index? }

  def image
    object.get_image
  end

  def full_name
    object.get_full_name
  end

  def date_entry
    I18n.l(object.date_entry, format: "%d de %B").downcase
  end

  def birthday
    I18n.l(object.birthday, format: "%d de %B").downcase
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

  def is_birthday_index?
    instance_options[:birthdays_index]
  end
end