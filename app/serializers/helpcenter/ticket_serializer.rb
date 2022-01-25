class Helpcenter::TicketSerializer < ActiveModel::Serializer
  attributes :id, :subcategory, :created_at, :closed_at, :status
  has_many :chat_messages, if: -> { is_show? }
  attribute :description, if: -> { is_show? }
  attribute :survey_answered, if: -> { is_show? }

  def subcategory
    object.subcategory.name
  end

  def created_at
    object.created_at.strftime('%d/%m/%Y %H:%M hrs')
  end

  def closed_at
    object.closed_at.strftime('%d/%m/%Y %H:%M hrs') if object.closed_at.present?
  end

  def survey_answered
    object.satisfaction_answers.present?
  end
  
  def status
    Helpcenter::Ticket::STATUS_ES[object.status]
  end

  def is_show?
    instance_options[:is_show]
  end
end
