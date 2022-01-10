class Helpcenter::TicketState < ApplicationRecord
  has_many :ticket_histories, class_name: 'Helpcenter::TicketHistory', foreign_key: :ticket_state_id
end
