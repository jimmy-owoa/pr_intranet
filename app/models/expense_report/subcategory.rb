class ExpenseReport::Subcategory < ApplicationRecord
  #validations
  validates :name, presence: true
    
  # Relations
  belongs_to :category, class_name: 'ExpenseReport::Category'
  has_many :request ,class_name: 'ExpenseReport::Request', foreign_key: :subcategory_id
end
