class General::BenefitGroup < ApplicationRecord
  validates_presence_of :name
  #relations
  has_many :general_users, class_name: "General::User", foreign_key: :benefit_group_id
  has_many :benefit_group_relationships, class_name: "General::BenefitGroupRelationship", foreign_key: :benefit_group_id
  has_many :benefits, -> { distinct }, through: :benefit_group_relationships

  def self.benefit_group_user(current_user)
    current_user.benefit_group_id.present? ? find(current_user.benefit_group_id) : "Sin Beneficios"
  end
end
