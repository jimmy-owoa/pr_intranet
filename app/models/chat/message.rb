class Chat::Message < ApplicationRecord
  belongs_to :room, class_name: "Chat::Room"
  belongs_to :user, class_name: "General::User", inverse_of: :messages, optional: true

  validates :message, presence: true
  has_many_attached :files
end
