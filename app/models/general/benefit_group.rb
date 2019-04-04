class General::BenefitGroup < ApplicationRecord
  #relations
  has_many :general_users, class_name: 'General::User', foreign_key: :benefit_group_id
  has_many :benefits_relationships, class_name: 'General::BenefitGroupRelationship', foreign_key: :benefit_id, inverse_of: :benefit_group
  has_many :benefits, through: :benefits_relationships
end
