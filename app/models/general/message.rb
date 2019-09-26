class General::Message < ApplicationRecord
  has_one_attached :image

  has_many :message_term_relationships, -> { where(object_type: "General::Message") },
           class_name: "General::TermRelationship", foreign_key: :object_id, inverse_of: :post
  has_many :terms, through: :message_term_relationships
  has_many :notifications
  has_many :user_messages, class_name: "General::UserMessage", foreign_key: :message_id, inverse_of: :message

  validates_presence_of :title

  MESSAGE_TYPES = [["Cumpleaños", "birthdays"], ["Bienvenidos", "welcomes"], ["General", "general"]]

  def get_name_message_types
    MESSAGE_TYPES.find { |s| s[1] == self.message_type }[0]
  end
end
