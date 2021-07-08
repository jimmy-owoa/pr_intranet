class News::Interaction < ApplicationRecord
  belongs_to :user, class_name: 'General::User'
  belongs_to :post, class_name: 'News::Post'

  validates :user_id, :post_id, presence: true
  validates :user_id, uniqueness: { scope: :post_id}

  enum type: ['I like', 'I love it', 'I enjoy', 'I surprises']
  validates :interaction_type, inclusion: { in: types.keys }
end