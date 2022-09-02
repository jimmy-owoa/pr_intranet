class ExpenseReport::RequestSerializer < ActiveModel::Serializer
  attributes :id, :total, :divisa_id, :description, :created_at, :closed_at, :status, :user,
  :society_id, :request_state_id,:country_id, :is_local, :destination_country_id, :payment_method_id, :bank_account_details, :invoices
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
      when 'borrador'
        'borrador'
      end
    else
      ''
    end
  end
  
  def invoices
    result = []
    object.invoices.each do |i| 
      result.push({
        id: i.id,
        total: i.total.to_s,
        description: i.description,
        category_id: i.category_id,
        file: i.file
      })
    end
    result
  end

  def user
    user = object.user 
    {full_name: user.full_name,
      user_id: user.id,
    }
  end

  def is_local
    object.is_local.to_s
  end
  
  # def is_show?
  #   instance_options[:is_show]
  # end
end
