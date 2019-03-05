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
      find_answer = Survey::Answer.where(question_id: params[:question_id], user_id: params[:user_id], option_id: params[:option_id]).try(:first)
      if find_answer.present?
        find_answer.destroy
      else
        respond_to do |format|
          if @answer.save
            format.json
          else
            format.html {render :new}
            format.json {render json: @answer.errors, status: :unprocessable_entity}
          end
        end      
      end
    end

    def answers_options_save_from_vue 
      answer = Survey::Answer.where(user_id: params[:user_id], question_id: params[:question_id]).try(:first) || Survey::Answer.new(user_id: params[:user_id], question_id: params[:question_id])
      if answer.present?
        answer.update(option_id: params[:option_id])
      else
        respond_to do |format|
          if answer.save
            format.json
          else
            format.html {render :new}
            format.json {render json: answer.errors, status: :unprocessable_entity}
          end
        end
      end
    end    

    def answers_save_from_vue
      answer = Survey::Answer.where(user_id: params[:user_id], question_id: params[:question_id]).try(:first) || Survey::Answer.new(user_id: params[:user_id], question_id: params[:question_id])
      answer.answer_variable = params[:answer_variable]
      respond_to do |format|
        if answer.save
          format.json
        else
          format.html {render :new}
          format.json {render json: answer.errors, status: :unprocessable_entity}
        end

      end
    end

    def check_data
      @survey = Survey::Survey.includes(questions: :answers).where(id: params[:survey_id]).where("survey_answers.user_id" => params[:user_id], "survey_questions.optional" => true)
      # @survey = Survey::Answer.includes(question: :survey).where(user_id:  2, "survey_questions.optional" => true, "survey_surveys.id" => params['survey_id'])
      if @survey.blank? #si está en blanco, puede pasar
        respond_to do |format|
          format.json { render json: 'ok' }
          format.js
        end
      else
        respond_to do |format|
          format.json { render json: @survey[0]}
          format.js
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
