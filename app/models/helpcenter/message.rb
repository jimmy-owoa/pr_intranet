class Helpcenter::Message < ApplicationRecord
  belongs_to :user, class_name: 'General::User'
  belongs_to :ticket, class_name: 'Helpcenter::Ticket'

  def format_created_at
    created_at.strftime('%H:%M hrs | %d/%m/%Y ')
  end
end
