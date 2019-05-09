class General::BenefitGroup < ApplicationRecord
  validates_presence_of :name
  #relations
  has_many :general_users, class_name: 'General::User', foreign_key: :benefit_group_id
  has_many :benefits_relationships, class_name: 'General::BenefitGroupRelationship', foreign_key: :benefit_group_id
  has_many :benefits, through: :benefits_relationships
end
