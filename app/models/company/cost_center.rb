class Company::CostCenter < ApplicationRecord
  has_many :cost_center_users, class_name: 'General::CostCenterUser', foreign_key: :cost_center_id, inverse_of: :cost_center
  has_many :users, class_name: "General::User", through: :cost_center_users
  validates_presence_of :name
end
