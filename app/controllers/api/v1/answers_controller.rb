module Api::V1
  class AnswersController < ApiController
    skip_before_action :verify_authenticity_token
    before_action :set_survey, only: [:create]

    def create
      for_email = []
      answered_form = Survey::AnsweredForm.create(survey: @survey, user: @request_user)
      params[:answers].each do |answer|
        options = Survey::Option.where(question_id: answer[:question_id])
        if options.present?
          option_ids = options.where(title: answer[:option]).pluck(:id)
          option_ids.each do |id|
            answer = answered_form.answers.create(question_id: answer[:question_id], option_id: id, user: @request_user)
          end
          for_email = add_email_show(for_email, Survey::Question.find(answer.question_id).title, Survey::Option.find(option_ids).pluck(:title))
        else
          answer = answered_form.answers.create(question_id: answer[:question_id], answer_variable: answer[:option], user: @request_user)
          for_email = add_email_show(for_email, Survey::Question.find(answer.question_id).title, answer.answer_variable)
        end
      end
      
      @survey.answered_times.create
      UserNotifierMailer.send_survey_answered(@request_user.email, for_email, @survey.name).deliver if @survey.present?

      render json: { success: true, message: "Answer created" }, status: :created
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

    def set_survey
      @survey = Survey::Survey.find_by_slug(params[:survey_slug])
    end
  end
end
