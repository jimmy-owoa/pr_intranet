module Frontend
  class AnswersController < FrontendController
    skip_before_action :verify_authenticity_token

    def create
      survey = nil
      for_email = []
      params[:_json].each do |answer|
        options = Survey::Option.where(question_id: answer[:questionId])
        if options.present?
          option_id = options.find_by_title(answer[:option]).id
          answer = Survey::Answer.create(question_id: answer[:questionId], option_id: option_id, user_id: @request_user.id)
          for_email = add_email_show(for_email, Survey::Question.find(answer.question_id).title, Survey::Option.find(option_id).title)
          survey = answer.question.survey
        else
          answer = Survey::Answer.create(question_id: answer[:questionId], answer_variable: answer[:option], user_id: @request_user.id)
          for_email = add_email_show(for_email, Survey::Question.find(answer.question_id).title, answer.answer_variable)
          survey = answer.question.survey
        end
      end
      survey.answered_times.create if survey.present?
      UserNotifierMailer.send_survey_answered(@request_user.email, for_email, survey.name).deliver if survey.present?

      respond_to do |format|
        format.json { render json: "OK", status: 200 }
      end
    end

    private

    def add_email_show(array, question, option)
      found = array.select { |a| a[:question] == question }
      if found.present?
        found.first[:answers].push(option)
      else
        array << { question: question, answers: [option] }
      end
      array
    end

    def answer_params
      params.require(:answer).permit(:user_id, :question_id, :option_id, :answer_variable)
    end
  end
end
