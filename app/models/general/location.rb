class General::Location < ApplicationRecord
  has_many :users, class_name: 'General::User', foreign_key: :location_id
  has_many :weathers, class_name: 'General::WeatherInformation', foreign_key: :location_id

  #scope
  scope :antofagasta, -> { where(name: 'Antofagasta').first }
  scope :santiago, -> { where(name: 'Santiago').first }
  scope :copiapo, -> { where(name: 'Copiapo').first }
  scope :la_serena, -> { where(name: 'La Serena').first }
  scope :vina_del_mar, -> { where(name: 'Vina del Mar').first }
  scope :rancagua, -> { where(name: 'Rancagua').first }
  scope :talca, -> { where(name: 'Talca').first }
  scope :concepcion, -> { where(name: 'Concepcion').first }
  scope :temuco, -> { where(name: 'Temuco').first }
  scope :puerto_montt, -> { where(name: 'Puerto Montt').first }    

end
