class Admin::AnswersController < ApplicationController
  layout 'admin'
  before_action :set_survey, only: [:show]

  def index
    @answers = Survey::Answer.all
  end

  def show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_survey
    @answer = Survey::Answer.find(params[:id])
    @question = Survey::Question.find(@answer.question_id)
    @survey = Survey::Survey.find(@question.survey_id)
  end
end
