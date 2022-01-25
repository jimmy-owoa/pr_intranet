class Helpcenter::TicketHistory < ApplicationRecord
  belongs_to :ticket, class_name: 'Helpcenter::Ticket', optional: true
  belongs_to :user, class_name: 'General::User', optional: true
  belongs_to :ticket_state, class_name: 'Helpcenter::TicketState', optional: true
end
