class ExpenseReport::RequestHistory < ApplicationRecord
  
  belongs_to :request, class_name: 'ExpenseReport::Request', optional: true
  belongs_to :user, class_name: 'General::User', optional: true
  belongs_to :request_state, class_name: 'ExpenseReport::RequestState', optional: true

  acts_as_paranoid
  
end
