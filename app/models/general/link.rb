class General::Link < ApplicationRecord
  include Rails.application.routes.url_helpers
  
  has_one_attached :image
  validates_presence_of :title
  validates_presence_of :image

  validates :image, content_type: ['image/gif', 'image/png', 'image/jpeg', 'image/webp']

  def get_image
    image.attached? ? url_for(image) : ""
  end
end