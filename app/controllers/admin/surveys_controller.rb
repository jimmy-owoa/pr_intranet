module Admin
  class SurveysController < AdminController
    before_action :set_survey, only: [:show, :destroy, :edit, :update]

    def index
      @surveys = Survey::Survey.order(created_at: :desc).all
    end

    def show
    end

    def new
      @survey = Survey::Survey.new
      @question = @survey.questions.build
      @question.options.build
    end

    def edit
      if @survey.questions.empty?
        @question = @survey.questions.build
        @question.options.build
      end
    end

    def create
      @survey = Survey::Survey.new(survey_params)
      respond_to do |format|
        if @survey.save
          format.html { redirect_to admin_surveys_path, notice: "Encuesta creada exitosamente." }
          format.json { render :show, status: :created, location: @survey }
        else
          format.html { render :new }
          format.json { render json: @survey.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @survey.update(survey_params)
          format.html { redirect_to admin_surveys_path, notice: "Encuesta editada exitosamente." }
          format.json { render :show, status: :ok, location: @survey }
        else
          format.html { render :edit }
          format.json { render json: @survey.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @survey.destroy
      respond_to do |format|
        format.html { redirect_to admin_surveys_path, notice: "Encuesta eliminada exitosamente." }
        format.json { head :no_content }
      end
    end

    private

    def check_object_exist(object)
      Survey::Survey.last == object
    end

    def set_tags
      # Getting terms_names from the form (tags)
      term_names = params[:terms_names]
      terms = []
      if term_names.present?
        term_names.uniq.each do |tag|
          terms << General::Term.where(name: tag, term_type: General::TermType.tag).first_or_create
        end
        @survey.terms.destroy_all unless check_object_exist(@survey) #no funcionó el new_record? ya que el objeto está creado
        # @survey.terms.destroy_all unless @survey.changed?
        @survey.terms << terms
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey::Survey.find(params[:id])
    end

    def survey_params
      params.require(:survey).permit(:name, :slug, :description, :show_name, :survey_type, :once_by_user, :image, :published_at, :finish_date, :status, :profile_id, :allowed_answers, terms_names: [], questions_attributes: [:id, :title, :description, :question_type, :optional, :_destroy, options_attributes: [:id, :title, :default, :placeholder, :_destroy]])
    end
  end
end
