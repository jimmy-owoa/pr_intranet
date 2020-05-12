class General::Section < ApplicationRecord
  has_one_attached :image
  validates :image, content_type: ['image/png', 'image/jpeg']
end
