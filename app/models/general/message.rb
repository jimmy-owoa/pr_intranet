class General::Message < ApplicationRecord
    has_one_attached :image
    TYPE = {0 => 'Cumpleaños', 1 => 'Bienvenidos', 2 => 'Generales'}
end
