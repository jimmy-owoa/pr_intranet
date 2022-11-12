class General::CostCenterUser < ApplicationRecord
  belongs_to :user, class_name: 'General::User', optional: true
  belongs_to :cost_center, class_name: 'Company::CostCenter', optional: true
end
