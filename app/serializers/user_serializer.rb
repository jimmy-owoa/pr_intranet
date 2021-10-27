class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :full_name, :last_name, :image, :legal_number, :country

  def country
    object.country.name
  end
  
  def image
    object.get_image
  end

  def full_name
    object.get_full_name
  end

  def is_welcome_index?
    instance_options[:is_welcome_index]
  end

  def is_birthday_index?
    instance_options[:birthdays_index]
  end
end