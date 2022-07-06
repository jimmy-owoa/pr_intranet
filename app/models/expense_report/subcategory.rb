class ExpenseReport::Subcategory < ApplicationRecord
  #validations
  validates :name, presence: true
    
  # Relations
  belongs_to :category, class_name: 'ExpenseReport::Category'
  has_many :invoices ,class_name: 'ExpenseReport::Invoice', foreign_key: :subcategory_id
end
