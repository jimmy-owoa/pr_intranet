class Company::CostCenter < ApplicationRecord
  has_many :users, class_name: 'General::User', foreign_key: :cost_center_id, inverse_of: :cost_center
end
