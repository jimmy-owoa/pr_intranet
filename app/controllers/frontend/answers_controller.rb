module Frontend
  class AnswersController < FrontendController
    skip_before_action :verify_authenticity_token

    def create
      survey = nil
      params[:_json].each do |answer|
        options = Survey::Option.where(question_id: answer[:questionId])
        if options.present?
          option_id = options.find_by_title(answer[:option]).id
          answer = Survey::Answer.create(question_id: answer[:questionId], option_id: option_id, user_id: @request_user.id)
          survey = answer.question.survey
          UserNotifierMailer.send_survey_answered(@request_user.email, survey.name).deliver
        else
          answer = Survey::Answer.create(question_id: answer[:questionId], answer_variable: answer[:option], user_id: @request_user.id)
          survey = answer.question.survey
        end
      end
      survey.answered_times.create if survey.present?
      respond_to do |format|
        format.json { render json: "OK", status: 200 }
      end
    end

    private

    def answer_params
      params.require(:answer).permit(:user_id, :question_id, :option_id, :answer_variable)
    end
  end
end
