class Admin::AnswersController < AdminController
  before_action :set_survey, only: [:show]

  def index
    @answers = Survey::Answer.all
    @surveys = Survey::Survey.all
  end

  def show
  end

  def report
    @survey = Survey::Survey.find(params[:id])
    render xlsx: 'report.xlsx.axlsx', filename: "reporte #{@survey.name + ' ' + l(Date.today, format: '%A %d %B %Y') }.xlsx"
  end

  private
  def set_survey
    @answer = Survey::Answer.find(params[:id])
    @question = Survey::Question.find(@answer.question_id)
    @survey = Survey::Survey.find(@question.survey_id)
    @option = Survey::Option.find(@answer.option_id) if @answer.option_id.present?
  end
end
