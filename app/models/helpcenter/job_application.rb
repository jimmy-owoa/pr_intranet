class Helpcenter::JobApplication < ApplicationRecord
  belongs_to :ticket, class_name: 'Helpcenter::Ticket'
  

  enum application_status: { enviada: 0, atendiendo: 1, cerrado: 2 }
  has_one_attached :file
end
