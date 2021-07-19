# frozen_string_literal: true

class General::Message < ApplicationRecord
  has_one_attached :image
  validates :image, content_type: ['image/png', 'image/jpeg']

  has_many :message_term_relationships, -> { where(object_type: 'General::Message') },
           class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :post
  has_many :terms, through: :message_term_relationships
  has_many :user_messages, class_name: 'General::UserMessage', foreign_key: :message_id, inverse_of: :message, dependent: :destroy

  belongs_to :profile, class_name: 'General::Profile', inverse_of: :messages, optional: true

  validates_presence_of :title
  validates_presence_of :image

  MESSAGE_TYPES = [%w[Cumpleaños birthdays], %w[Bienvenidos welcomes], %w[General general]].freeze

  def get_name_message_types
    MESSAGE_TYPES.find { |s| s[1] == message_type }[0]
  end

  def set_users
    if message_type == "birthdays"
      birthday_users = General::User.users_birthday_today

      birthday_users.each do |user|
        um = General::UserMessage.where(user_id: user.id, message_id: id).first_or_create

        if um.viewed_at.present? && um.viewed_at.to_date < Date.today
          um.update(viewed_at: nil)
        end
      end
    end

    if message_type == "welcomes"
      welcome_users = General::User.where(date_entry: (Date.today - 100.days)..Date.today)

      welcome_users.each do |user|
        General::UserMessage.where(user_id: user.id, message_id: id).first_or_create
      end
    end

    if message_type == "general"
      users_match = General::User.includes(:profiles).where(general_profiles: { id: profile_id })
      users_del = user_messages.pluck(:user_id) - users_match.pluck(:id)
      user_messages.where(user_id: users_del).delete_all if users_del.present?
      users_match.each do |user|
        General::UserMessage.where(user_id: user.id, message_id: id).first_or_create
      end
    end
  end
end
