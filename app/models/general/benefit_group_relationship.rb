class General::BenefitGroupRelationship < ApplicationRecord
  acts_as_paranoid
  belongs_to :benefit, foreign_key: :benefit_id, class_name: 'General::Benefit'
  belongs_to :benefit_group, foreign_key: :benefit_group_id, class_name: 'General::BenefitGroup'
end
