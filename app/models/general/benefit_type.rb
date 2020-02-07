class General::BenefitType < ApplicationRecord
  has_many :benefits, class_name: "General::Benefit", foreign_key: :benefit_type_id, inverse_of: :benefit_type
end
