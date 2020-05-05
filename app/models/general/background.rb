class General::Background < ApplicationRecord
  has_one_attached :image

  scope :current, -> { where("starts <= ? AND ends >= ?", Date.today, Date.today) }
end
