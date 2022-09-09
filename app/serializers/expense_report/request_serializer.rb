class ExpenseReport::RequestSerializer < ActiveModel::Serializer
  attributes :id, :total, :divisa_id, :description, :created_at, :closed_at, :status, :user,
  :society_id, :request_state_id,:country_id, :is_local, :destination_country_id, :payment_method_id, :bank_account_details, :invoices, :files

  def created_at
    object.created_at.strftime('%d/%m/%Y %H:%M hrs')
  end

  def closed_at
    object.closed_at.strftime('%d/%m/%Y %H:%M hrs') if object.closed_at.present?
  end
  
  def status
    if object.request_state.present?
      object.request_state.code
    else
      ''
    end
  end
  
  def invoices
    result = []
    object.invoices.each do |i| 
      files = []
      files_url = []
      i.files.each do |file|
        files << file
        files_url << {url: url_for(file), id: file.id }
      end
      result.push({
        id: i.id,
        total: i.total.to_s,
        description: i.description,
        category_id: i.category_id,
        files: files,
        files_url: files_url
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

  def files 
    files = []
    object.files.each do |file|
      files << {url: url_for(file), id: file.id }
    end
    return files
  end
  
  # def is_show?
  #   instance_options[:is_show]
  # end
end
