class Helpcenter::JobApplication < ApplicationRecord
  belongs_to :ticket, class_name: 'Helpcenter::Ticket'
  

  enum application_status: { recibida: 0, en_revision: 1, preseleccionada: 2, evaluacion: 3, no_seleccionada: 4, seleccionado: 5}
  has_one_attached :file
end
