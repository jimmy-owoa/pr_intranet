class General::File < ApplicationRecord
  has_one_attached :file
  
  belongs_to :posts, class_name: 'News::Post', optional: true
end
