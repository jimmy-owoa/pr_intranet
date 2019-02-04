class Admin::AnswersController < ApplicationController
  layout 'admin'
  before_action :set_survey, only: [:show]

  def index
    @answers = Survey::Answer.all
    @surveys = Survey::Survey.all
  end

  def show
  end

  private
  def set_survey
    @answer = Survey::Answer.find(params[:id])
    @question = Survey::Question.find(@answer.question_id)
    @survey = Survey::Survey.find(@question.survey_id)
    @option = Survey::Option.find(@answer.option_id) if @answer.option_id.present?
  end
end
