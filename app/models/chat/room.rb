class Chat::Room < ApplicationRecord
  has_many :messages, class_name: 'Chat::Message', foreign_key: :room_id
end
