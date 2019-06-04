class General::Benefit < ApplicationRecord
  has_one_attached :image
  has_many :benefit_term_relationships, -> {where(object_type: 'General::Benefit')},
            class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :benefit
  has_many :terms, through: :benefit_term_relationships
  has_many :benefit_group_relationships, class_name: 'General::BenefitGroupRelationship', foreign_key: :benefit_id
  has_many :benefit_groups, -> { distinct }, through: :benefit_group_relationships
  
  belongs_to :benefit_type

  accepts_nested_attributes_for :terms
  accepts_nested_attributes_for :benefit_groups

  validates_presence_of :title

  def self.allowed_by_benefit_group(benefit_group_id)
    includes(:benefit_groups).where(general_benefit_groups: { id: benefit_group_id }) if benefit_group_id.present?
  end

  def self.user_benefits current_user
    if current_user.has_role? :super_admin
      General::Benefit.order(id: :desc).all
    elsif current_user.has_role? :benefit_admin
      current_user.benefit_group.present? ? current_user.benefit_group.benefits.order(id: :desc) : "Sin Grupo Beneficiario"
    end
  end
end
