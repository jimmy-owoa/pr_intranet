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
      "schedule"
    ]
  end

  has_many :user_profiles, class_name: 'General::UserProfile', foreign_key: :profile_id, inverse_of: :profile
  has_many :profile_attributes, class_name: 'General::ProfileAttribute', foreign_key: :profile_id, inverse_of: :profile
  has_many :users, through: :user_profiles

  has_many :posts, class_name: 'News::Post', foreign_key: :profile_id, inverse_of: :profile

  def set_users
    query = "1"
    Classes::ALL.each do |class_name|
      profile_attributes_where = self.profile_attributes.where(class_name: class_name).map{|v| "'#{v.value}'"}.join(',')
      query += " AND #{class_name} IN (#{profile_attributes_where})" if profile_attributes_where.present?
    end

    General::User.where(query).each do |user|
      self.users << user
    end
  end
end

# "location_regions", # model
#       "general_benefit_group", # model
#       "company", # model
#       "company_management", # model
#       "company_cost_center", # model