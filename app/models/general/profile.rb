class General::Profile < ApplicationRecord
  class Classes
    ALL = [
      "benefit_group",
      "office_city",
      "is_boss",
      "cost_center",
      "management",
      "company",
      "position_classification",
      "employee_classification",
      "office_region",
      "gender",
      "office_country",
      "has_children",
    ]
  end

  has_many :user_profiles, class_name: "General::UserProfile", foreign_key: :profile_id, inverse_of: :profile, dependent: :destroy
  has_many :profile_attributes, class_name: "General::ProfileAttribute", foreign_key: :profile_id, inverse_of: :profile
  has_many :users, through: :user_profiles

  has_many :posts, class_name: "News::Post", foreign_key: :profile_id, inverse_of: :profile
  has_many :messages, class_name: "General::Message", foreign_key: :profile_id, inverse_of: :profile
  has_many :menus, class_name: "General::Menu", foreign_key: :profile_id, inverse_of: :profile
  has_many :surveys, class_name: "Survey::Survey", foreign_key: :profile_id, inverse_of: :profile

  # def set_users
  #   query = "1"
  #   Classes::ALL.each do |class_name|
  #     profile_attributes_where = self.profile_attributes.where(class_name: class_name).map { |v| "'#{v.value}'" }.join(",")
  #     query += " AND #{class_name} IN (#{profile_attributes_where})" if profile_attributes_where.present?
  #   end

  #   query_profile_users = General::User.includes(:profiles).where(query).uniq
  #   if query_profile_users.present?
  #     new_users = query_profile_users - self.users
  #     remove_users = self.users - query_profile_users
  #   end

  #   if new_users.present?
  #     new_users.each do |user|
  #       self.users << user
  #     end
  #   end

  #   if remove_users.present?
  #     remove_users.each do |user|
  #       General::UserProfile.where(user_id: user.id, profile_id: self.id).destroy_all
  #     end
  #   end
  # end

  # vamos a hacer un listado de todos los filtros ordenados por prioridad
  # recorrer todos los filtros que nos entregara un listado de usuarios

  def set_users
    query = "1"
    class_name = nil
    users_ids = General::User.all.pluck(:id)
    Classes::ALL.each do |class_name|
      if self.profile_attributes.where(class_name: class_name).present?
        values = self.profile_attributes.where(class_name: class_name).pluck(:value)
        users_ids = General::UserAttribute.where(user_id: users_ids).where(attribute_name: class_name, value: values).pluck(:user_id).uniq
      end
    end

    query_profile_users = General::User.where(id: users_ids)
    if query_profile_users.present?
      new_users = query_profile_users - self.users
      remove_users = self.users - query_profile_users
    end

    if new_users.present?
      new_users.each do |user|
        self.users << user
      end
    end

    if remove_users.present?
      remove_users.each do |user|
        General::UserProfile.where(user_id: user.id, profile_id: self.id).destroy_all
      end
    end
  end

  def set_query(class_name, query)
    profile_attributes_where = self.profile_attributes.where(class_name: class_name).map { |v| "'#{v.value}'" }.join(",")
    query + " AND (attribute_name = '#{class_name}' AND value IN (#{profile_attributes_where}))" if profile_attributes_where.present?
  end

  # "1 AND (attribute_name = 'gender' AND value IN ('Masculino, femenino')) AND (attribute_name = 'company' AND value IN ('2'))"
end
