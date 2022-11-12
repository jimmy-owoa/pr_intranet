class ExpenseReport::RequestState < ApplicationRecord
  #validations
  #validates :name, presence: true
  
  has_many :request_histories, class_name: 'ExpenseReport::RequestHistory', foreign_key: :request_state_id
  has_many :requests, class_name: 'ExpenseReport::Request', foreign_key: :request_state_id

end
