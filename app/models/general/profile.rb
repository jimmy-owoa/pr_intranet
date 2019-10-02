class General::Profile < ApplicationRecord
  class Classes
    ALL = [
      "gender",
      "position_classification",
      "is_boss",
      "employee_classification",
      "has_children",
      "syndicate_member",
      "contract_type",
      "rol",
      "schedule",
    ]
  end

  has_many :user_profiles, class_name: "General::UserProfile", foreign_key: :profile_id, inverse_of: :profile, dependent: :destroy
  has_many :profile_attributes, class_name: "General::ProfileAttribute", foreign_key: :profile_id, inverse_of: :profile
  has_many :users, through: :user_profiles

  has_many :posts, class_name: "News::Post", foreign_key: :profile_id, inverse_of: :profile
  has_many :messages, class_name: "General::Message", foreign_key: :profile_id, inverse_of: :profile

  def set_users
    query = "1"
    Classes::ALL.each do |class_name|
      profile_attributes_where = self.profile_attributes.where(class_name: class_name).map { |v| "'#{v.value}'" }.join(",")
      query += " AND #{class_name} IN (#{profile_attributes_where})" if profile_attributes_where.present?
    end

    query_profile_users = General::User.includes(:profiles).where(query).uniq
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
end

# "location_regions",
#       "general_benefit_group",
#       "company",
#       "company_management",
#       "company_cost_center",
