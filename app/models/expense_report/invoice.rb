class ExpenseReport::Invoice < ApplicationRecord

  # Relations
  belongs_to :request, class_name: "ExpenseReport::Request" 
end
