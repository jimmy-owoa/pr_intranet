class Frontend::SurveysController < ApplicationController

  def index
    surveys = Survey::Survey.includes(questions: :options)
    data_surveys = []
    surveys.each do |survey|
      data_questions = [] 
      survey.questions.each do |question|
        data_options = []
        question.options.each do |option|
          data_options << {
            id: option.id,
            title: option.title,
            default: option.default,
            placeholder: option.placeholder
          }
        end
        data_questions << {
          id: question.id,
          title: question.title,
          question_type: question.question_type,
          optional: question.optional,
          options: data_options 
        }
      end
      data_surveys << {
        id: survey.id,
        name: survey.name,
        show_name: survey.show_name,
        image: survey.image.attached? ? 
        url_for(survey.image) : root_url + '/assets/survey.png',
        created_at: survey.created_at.strftime('%d-%m-%Y'),
        questions: data_questions,
        survey_type: survey.survey_type,
        slug: survey.slug
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: data_surveys }
      format.js
    end
  end

  def create
    @answer = Survey::Answer.new(answer_params)
    respond_to do |format|
      if @answer.save
        format.html { redirect_to frontend_surveys_path, notice: 'Answer was successfully created.'}
        format.json { render :show, status: :created, location: @answer}
      else
        format.html {render :new}
        format.json {render json: @answer.errors, status: :unprocessable_entity}
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_survey
    @survey = Survey::Survey.find(params[:id])
  end

  def answer_params
    params.require(:survey).permit(:user_id, :question_id, :option_id)
  end
end

