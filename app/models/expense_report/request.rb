class ExpenseReport::Request < ApplicationRecord
  include ActionView::Helpers::DateHelper
  #validations
  validates :description, presence: true

  # Relations
  belongs_to :user, class_name: "General::User"
  belongs_to :assistant, class_name: "General::User", optional: true
  belongs_to :subcategory, class_name: "ExpenseReport::Subcategory"
  belongs_to :society, class_name: "General::Society"
  belongs_to :request_state, class_name: "ExpenseReport::RequestState"
  has_many :request_histories, class_name: "ExpenseReport::RequestHistory", foreign_key: :request_id
  has_many :invoices, class_name: "ExpenseReport::Invoice", foreign_key: :request_id

   def total_time
     if closed_at.present?
       distance_of_time_in_words(created_at, closed_at)
     else
       distance_of_time_in_words(created_at, DateTime.now)
     end
   end

   def time_worked
     return "0 minutos" if self.request_histories.nil?

     if closed_at.present?
       distance_of_time_in_words(attended_at, closed_at)
     else
       distance_of_time_in_words(attended_at, DateTime.now)
     end
   end

   def attended_at
      self.request_histories.first.created_at
   end
end
