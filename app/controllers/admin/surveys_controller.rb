module Admin 
  class SurveysController < ApplicationController
    layout 'admin'
    before_action :set_survey, only: [:show, :destroy, :edit, :update]
  
    def index
      @surveys = Survey::Survey.all
    end
  
    def show
    end
  
    def new
      @survey = Survey::Survey.new
      @survey.questions.build
      @survey_types = Survey::Survey::SURVEY_TYPES
    end
  
    def edit
      @survey.questions.build
      @survey_types = Survey::Survey::SURVEY_TYPES
    end
  
    def create
      @survey = Survey::Survey.new(survey_params)
      respond_to do |format|
        if @survey.save
          format.html { redirect_to admin_surveys_path, notice: 'Encuesta creada exitosamente.'}
          format.json { render :show, status: :created, location: @survey}
        else
          format.html {render :new}
          format.json {render json: @survey.errors, status: :unprocessable_entity}
        end
      end
    end
  
    def update
      respond_to do |format|
        if @survey.update(survey_params)
          format.html { redirect_to admin_surveys_path, notice: 'Encuesta editada exitosamente.'}
          format.json { render :show, status: :ok, location: @survey }
        else
          format.html { render :edit}
          format.json { render json: @survey.errors, status: :unprocessable_entity}
        end
      end
    end
  
    def destroy
      @survey.destroy
      respond_to do |format|
        format.html { redirect_to admin_surveys_path, notice: 'Encuesta eliminada exitosamente.'}
        format.json { head :no_content }
      end
    end
  
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey::Survey.find(params[:id])
    end
  
    def survey_params
      params.require(:survey).permit(:name, :slug, :survey_type, questions_attributes: [:id, :title, :description, :question_type, :_destroy, options_attributes: [:id, :title, :default, :placeholder, :_destroy]])
    end
  end
end