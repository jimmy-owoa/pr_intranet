class Helpcenter::Ticket < ApplicationRecord
  include ActionView::Helpers::DateHelper

  # validations
  validates :description, presence: true
  # relations
  belongs_to :user, class_name: "General::User"
  belongs_to :assistant, class_name: "General::User", optional: true
  belongs_to :subcategory, class_name: "Helpcenter::Subcategory"
  has_many :chat_messages, class_name: "Helpcenter::Message", foreign_key: :ticket_id
  has_many :satisfaction_answers, class_name: "Helpcenter::SatisfactionAnswer", foreign_key: :ticket_id
  # active storage
  has_many_attached :files
  # ENUM
  STATUS = [
    "Abierto",
    "Atendido",
    "Cerrado",
  ].freeze

  STATUS_COLLECTION = { "" => "Todos", "Abierto" => "Abiertos", "Atendido" => "Atendidos", "Cerrado" => "Cerrados" }.freeze

  before_create :set_status

  def set_status
    self.status = "Abierto"
  end

  def format_closed_at
    closed_at.strftime("%d/%m/%Y %H:%M hrs")
  end

  def total_time
    if closed_at.present?
      distance_of_time_in_words(created_at, closed_at)
    else
      distance_of_time_in_words(created_at, DateTime.now)
    end
  end

  def time_worked
    return "0 minutos" if attended_at.nil?

    if closed_at.present?
      distance_of_time_in_words(attended_at, closed_at)
    else
      distance_of_time_in_words(attended_at, DateTime.now)
    end
  end

  def self.ticket_boss_notifications(encrypted_data)
    decrypted_back = decrypt_data(encrypted_data)
    ticket = Helpcenter::Ticket.find(decrypted_back[:ticket_id])
    request_user = ticket.user
    time_expiry = ticket.created_at + 1.years
    if DateTime.now >= time_expiry
      return "link_expired" 
    else
      if decrypted_back[:aproved_to_review] == false
        UserNotifierMailer.notification_ticket_rejected_to_boss(ticket, request_user).deliver
        UserNotifierMailer.notification_ticket_rejected_to_user(ticket, request_user).deliver
        ticket.destroy
        return "rejected"
      else
        ticket.update(aproved_to_review: DateTime.now)
        UserNotifierMailer.notification_new_ticket(ticket, request_user).deliver
        UserNotifierMailer.notification_ticket_approved_to_boss(ticket, request_user).deliver
        UserNotifierMailer.notification_ticket_approved_to_user(ticket, request_user).deliver
        return "approved"
      end
    end
  end

  def self.decrypt_data(data)
    encrypted_data = Base64.decode64(data)
    key = Rails.application.credentials[:secret_key_base][0..31]
    crypt = ActiveSupport::MessageEncryptor.new(key)
    decrypted_back = crypt.decrypt_and_verify(encrypted_data)
    decrypted_back
  end
end