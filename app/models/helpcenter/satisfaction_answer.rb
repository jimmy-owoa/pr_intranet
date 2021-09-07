class Helpcenter::SatisfactionAnswer < ApplicationRecord
  belongs_to :user, class_name: 'General::User'
  belongs_to :ticket, class_name: 'Helpcenter::Ticket'

  validates :user_id, uniqueness: { scope: :ticket_id}
end
