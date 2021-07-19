class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :question_type, :options, :required
  
  def options
    object.options.map do |option|
      {
        id: option.id,
        title: option.title,
        default: option.default,
        placeholder: option.placeholder,
      }
    end
  end
end