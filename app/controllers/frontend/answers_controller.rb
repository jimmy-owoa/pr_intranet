class Frontend::AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :destroy, :edit, :update]
  
    def index
      @answers = Survey::Answer.all
    end
  
    def new
      @answer = Survey::Answer.new
    end
  
    def create
      @answer = Survey::Answer.new(answer_params)
      respond_to do |format|
        if @answer.save
          format.json
        else
          format.html {render :new}
          format.json {render json: @answer.errors, status: :unprocessable_entity}
        end
      end
    end
  
    def update
      respond_to do |format|
        if @answer.update(answer_params)
          format.html { redirect_to admin_survey_path(@answer), notice: 'Answer was successfully updated.'}
          format.json { render :show, status: :ok, location: @answer }
        else
          format.html { render :edit}
          format.json { render json: @answer.errors, status: :unprocessable_entity}
        end
      end
    end
  
    def destroy
      @answer.destroy
      respond_to do |format|
        format.html { redirect_to admin_surveys_path, notice: 'Answer was successfully destroyed.'}
        format.json { head :no_content }
      end
    end
  
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Survey::Answer.find(params[:id])
    end

    def set_survey
      @survey = Survey::Survey.find(params[:id])
    end
  
    def answer_params
      params.require(:answer).permit(:user_id, :question_id, :option_id,:answer_variable)
    end
end
