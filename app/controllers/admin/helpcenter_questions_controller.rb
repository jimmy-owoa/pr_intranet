module Admin
  class HelpcenterQuestionsController < AdminController
    before_action :set_question, only: [:edit, :show, :destroy, :update]
    before_action :check_admin

    def index
      @questions = Helpcenter::Question.all
    end

    def new
      @question = Helpcenter::Question.new
      @subcategories = []
    end

    def edit
      @subcategories = Helpcenter::Subcategory.where(category: @question.subcategory.category)
    end

    def show

    end

    def subcategories
      @subcategories = Helpcenter::Subcategory.where(category_id: params[:category_id])
      render :partial => "admin/helpcenter_questions/subcategories", :object => @subcategories
    end

    def create
      @question = Helpcenter::Question.new(question_params)
      respond_to do |format|
        if @question.save
          format.html { redirect_to admin_helpcenter_question_path(@question), notice: 'Pregunta fue creada con éxito.' }
          format.json { render :show, status: :created, location: @question }
          format.js
        else
          format.html { render :new }
          format.json { render json: @question.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def update
      respond_to do |format|
        if @question.update(question_params)
          format.html { redirect_to admin_helpcenter_question_path(@question), notice: 'Pregunta fue actualizada con éxito.' }
          format.json { render :show, status: :ok, location: @question }
        else
          format.html { render :edit }
          format.json { render json: @question.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @question.destroy
      respond_to do |format|
        format.html { redirect_to admin_helpcenter_questions_path, notice: 'Pregunta fue eliminada con éxito.' }
        format.json { head :no_content }
      end
    end

    private

    def set_question
      @question = Helpcenter::Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:name, :content, :subcategory_id, :important)
    end
  end
end
