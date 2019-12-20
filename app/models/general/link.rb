class General::Link < ApplicationRecord
  has_one_attached :image
  validates_presence_of :title
  validates_presence_of :image

  validates :image, content_type: ['image/gif', 'image/png', 'image/jpeg', 'image/webp']
end