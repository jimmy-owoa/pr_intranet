class General::Background < ApplicationRecord
  has_one_attached :image
  validates :image, content_type: ['image/png', 'image/jpeg']

  scope :current, -> { where("starts <= ? AND ends >= ?", Date.today, Date.today) }
end
