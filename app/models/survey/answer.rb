class Survey::Answer < ApplicationRecord
  belongs_to :option, optional: true
  belongs_to :question, optional: true
  belongs_to :user, class_name: 'General::User', optional: true
  before_save :set_question_id, :already_answered

  # validate :already_answered

  def already_answered
    # binding.pry
    throw :abort if Survey::Answer.exists?(user_id: user_id, question_id: question_id, option_id: option_id)

    # if answer_variable.present?
    #   binding.pry
    #   Survey::Answer.where(user_id: user_id, question_id: question_id).first_or_create.update(answer_variable: answer_variable)
    # else
    #   Survey::Answer.where(user_id: user_id, question_id: question_id, option_id: option_id).first_or_create.update(option_id: option_id)
    # end

    # # Survey::Answer.where(user_id: user_id, question_id: question_id, option_id: option_id).first_or_create.update(option_id: option_id)
    # def check_answer(user_id, question_id, option_id=nil)
    #   if answer_variable.present?
        
    #   end
    #   answer = where(user_id: user_id, question_id: question_id, option_id: option_id)
    #   if answer.nil?
    #     answer = create(user_id: user_id, question_id: question_id, option_id: option_id)
    #   else
    #     answer.udpate_attributes()
    #   end
    end

  end

  def set_question_id
    self.question_id ||= Survey::Option.find(option_id).question_id 
  end
end
