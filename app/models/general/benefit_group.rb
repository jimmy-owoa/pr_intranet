class General::BenefitGroup < ApplicationRecord
  #relations
  has_many :general_benefits, class_name: 'General::Benefit', foreign_key: :benefit_group_id
  has_many :general_users, class_name: 'General::User', foreign_key: :benefit_group_id
end
