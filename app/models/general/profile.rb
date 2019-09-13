class General::Profile < ApplicationRecord
  class Attributes
    ALL = [
      POSITION_CLASSIFICATION = "position_classification",
      IS_BOSS = "is_boss",
      EMPLOYEE_CLASSIFICATION = "employee_classification",
      HAS_CHILDREN = "has_children"
    ]
    GENDER = [
      MASCULINO = "masculino",
      FEMENINO = "femenino"
    ]
  end

  Attributes::GENDER.each do |attr|
    scope attr, ->{ where(value: attr) }
  end

  has_many :user_profiles, class_name: 'General::UserProfile', foreign_key: :profile_id, inverse_of: :profile
  has_many :profile_attributes, class_name: 'General::ProfileAttribute', foreign_key: :profile_id, inverse_of: :profile

end
