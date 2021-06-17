class General::Section < ApplicationRecord
  include Rails.application.routes.url_helpers
  
  has_one_attached :image
  validates :image, content_type: ['image/png', 'image/jpeg']

  def get_image
    image.attached? ? url_for(image) : ""
  end
end
