class ExpenseReport::RequestSerializer < ActiveModel::Serializer
  attributes :id, :total, :divisa_id, :description, :created_at, :closed_at, :status
  # has_many :invoices

  def created_at
    object.created_at.strftime('%d/%m/%Y %H:%M hrs')
  end

  def closed_at
    object.closed_at.strftime('%d/%m/%Y %H:%M hrs') if object.closed_at.present?
  end
  
  def status
    if object.request_state.present?
      case object.request_state.code 
      when 'abierto'
        'aprobado'
      when 'atendiendo'
        'atendiendo'
      when 'en revisión'
        'enviado'
      when 'resuelto'
        'resuelto'
      end
    else
      ''
    end
    

  end
  # def is_show?
  #   instance_options[:is_show]
  # end
end
