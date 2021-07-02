class BirthSerializer < ActiveModel::Serializer
  attributes :email, :child_name, :child_lastname, :child_lastname2, :birthday, :image, :color, :company, :father_name, :gender

  def image
    object.get_image
  end

  def birthday
    I18n.l(object.birthday, format: "%d de %B").downcase
  end

  def father_name
    object.user.get_full_name
  end

  def email
    object.user.email
  end

  def color
    object.user.get_color
  end

  def company
    object.user.company.try(:name)
  end

  def is_index?
    instance_options[:is_index]
  end
end