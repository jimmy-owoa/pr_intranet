class General::Message < ApplicationRecord
  has_one_attached :image
  validates :image, content_type: ['image/png', 'image/jpeg']

  has_many :message_term_relationships, -> { where(object_type: "General::Message") },
           class_name: "General::TermRelationship", foreign_key: :object_id, inverse_of: :post
  has_many :terms, through: :message_term_relationships
  has_many :notifications
  has_many :user_messages, class_name: "General::UserMessage", foreign_key: :message_id, inverse_of: :message, dependent: :destroy

  belongs_to :profile, class_name: "General::Profile", inverse_of: :messages, optional: true

  validates_presence_of :title
  validates_presence_of :image

  MESSAGE_TYPES = [["Cumpleaños", "birthdays"], ["Bienvenidos", "welcomes"], ["General", "general"]]

  def get_name_message_types
    MESSAGE_TYPES.find { |s| s[1] == self.message_type }[0]
  end

  def set_users
    user_messages = General::User.includes(:profiles).where(general_profiles: { id: self.profile_id })
    users = self.user_messages
    users_del = users - user_messages
    self.user_messages.where(user_id: users_del.pluck(:user_id)).delete_all if users_del.present?
    user_messages.each do |user|
      General::UserMessage.where(user_id: user.id, message_id: self.id).first_or_create
    end

    # if remove_messages.present?
    #   remove_messages.each do |um|
    #     General::UserMessage.where(user_id: user.id, profile_id: self.profile_id).destroy_all
    #   end
    # end
  end
end
