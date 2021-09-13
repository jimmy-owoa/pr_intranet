class Helpcenter::MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :user_id

  def created_at
    object.created_at.strftime('%d/%m/%Y %H:%M hrs')
  end

  def is_show?
    instance_options[:is_show]
  end
end