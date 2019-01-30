class Admin::AnswersController < ApplicationController
  layout 'admin'
  before_action :set_survey, only: [:show]

  def index
    @answers = Survey::Answer.all
  end

  def show
  end

  private
  def set_survey
    @answer = Survey::Answer.find(params[:id])
    @option = Survey::Option.find(@answer.option_id)
    @question = @option.question
    @survey = Survey::Survey.find(@question.survey_id)
  end
end
