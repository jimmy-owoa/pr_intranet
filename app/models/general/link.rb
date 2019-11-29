class General::Link < ApplicationRecord
  has_one_attached :image
  validates_presence_of :title
  validates_presence_of :image
end
