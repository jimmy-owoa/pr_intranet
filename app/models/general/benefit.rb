class General::Benefit < ApplicationRecord
  has_one_attached :image
  has_many :benefit_term_relationships, -> {where(object_type: 'General::Benefit')},
            class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :benefit
  has_many :terms, through: :benefit_term_relationships
  has_many :benefit_group_relationships, class_name: 'General::BenefitGroupRelationship', foreign_key: :benefit_id, inverse_of: :benefit

  has_many :benefit_groups, through: :benefit_group_relationships

  accepts_nested_attributes_for :terms
end
