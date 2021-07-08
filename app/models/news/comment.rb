class News::Comment < ApplicationRecord
  belongs_to :post, class_name: 'News::Post'
  belongs_to :user, class_name: 'General::User'

  validates :content, :user_id, :post_id, presence: true
  validates :content, length: { maximum: 250 }
end
