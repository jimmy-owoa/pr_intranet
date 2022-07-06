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
    object.request_state.present? ? object.request_state.code : ''
  end
  # def is_show?
  #   instance_options[:is_show]
  # end
end
