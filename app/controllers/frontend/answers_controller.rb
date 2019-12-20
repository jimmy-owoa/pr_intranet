module Frontend
  class AnswersController < FrontendController
    skip_before_action :verify_authenticity_token

    def create
      params[:_json].each do |answer|
        options = Survey::Option.where(question_id: answer[:questionId])
        if options.present?
          option_id = options.find_by_title(answer[:option]).id
          Survey::Answer.create(question_id: answer[:questionId], option_id: option_id, user_id: @request_user.id)
        else
          Survey::Answer.create(question_id: answer[:questionId], answer_variable: answer[:option], user_id: @request_user.id)
        end
      end
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
