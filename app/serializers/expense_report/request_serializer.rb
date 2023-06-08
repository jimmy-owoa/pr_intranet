class ExpenseReport::RequestSerializer < ActiveModel::Serializer
  attributes :id, :total, :divisa_id, :description, :created_at, :closed_at, :status, :user, :payment_date,
  :society_id, :request_state_id,:country_id, :is_local, :destination_country_id, :payment_method_id, :bank_account_details, :invoices, :files, :messages, :supervisor, :society
  include Rails.application.routes.url_helpers

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

  def destination_country_id
    ExpenseReport::Request.destination_country_ids[object.destination_country_id]
  end

  def payment_date
    if object.try(:payment_date).present?
      I18n.l(object.try(:payment_date), format: "%A, %d de %B de %Y") 
    else
      'No definida'
    end
  end

  def messages
    data_messages = []
    messages = Chat::Room.where(resource_id: object.id, resource_type: 'ExpenseReport::Request').last.try(:messages) || []
      messages.each do |m|
        files = []
        m.files.each do |file|
          files << root_url + rails_blob_path(file, disposition: "attachment")
        end
        data_messages << {
          message: m.message,
          user: m.user,
          files: files,
          created_at: distance_of_time_in_words(m.created_at, Time.now)
        }
      end
  end
  
  def supervisor
    object.user.get_supervisor_full_name
  end

  def society 
    object.society.name
  end
  
  # def is_show?
  #   instance_options[:is_show]
  # end
end
