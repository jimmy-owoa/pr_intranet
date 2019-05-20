class General::Benefit < ApplicationRecord
  has_one_attached :image
  has_many :benefit_term_relationships, -> {where(object_type: 'General::Benefit')},
            class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :benefit
  has_many :terms, through: :benefit_term_relationships
  has_many :benefit_group_relationships, class_name: 'General::BenefitGroupRelationship', foreign_key: :benefit_id
  has_many :benefit_groups, through: :benefit_group_relationships

  belongs_to :benefit_type 
  
  accepts_nested_attributes_for :terms
  accepts_nested_attributes_for :benefit_groups

  validates_presence_of :title, :benefit_group_id
  
  def self.allowed_by_benefit_group(benefit_group_id)
    includes(:benefit_groups).where(general_benefit_groups: { id: benefit_group_id }) if benefit_group_id.present?
  end

  def benefit_group
    General::BenefitGroup.find(self.benefit_group_id)
  end
end
