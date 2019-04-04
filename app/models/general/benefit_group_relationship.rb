class General::BenefitGroupRelationship < ApplicationRecord
  belongs_to :benefit, foreign_key: :benefit_id, class_name: 'General::Benefit', optional: true, inverse_of: :benefit_relationships
  belongs_to :benefit_group, foreign_key: :benefit_group_id, class_name: 'General::BenefitGroup', optional: true, inverse_of: :benefit_group_relationships
end
