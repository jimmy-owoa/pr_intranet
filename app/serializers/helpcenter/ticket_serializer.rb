class Helpcenter::TicketSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :status, :years_of_experience, :required_education, :shift, :requested_position_title, :careers
  # has_many :chat_messages, if: -> { is_show? }
  # attribute :description, if: -> { is_show? }
  # attribute :survey_answered, if: -> { is_show? }


  def created_at
    object.created_at.strftime('%d/%m/%Y %H:%M hrs')
  end

  
  def status
    Helpcenter::Ticket::STATUS_ES[object.status]
  end

  def years_of_experience 
    object.years_of_experience.gsub('_', ' ').capitalize()
  end

  def required_education 
    object.required_education.gsub('_', ' ').capitalize()
  end

  def requested_position_title 
    object.requested_position_title.gsub('_', ' ').capitalize()
  end

  def careers 
    object.careers.gsub('_', ' ').capitalize()
  end
  

  # def is_show?
  #   instance_options[:is_show]
  # end
end
