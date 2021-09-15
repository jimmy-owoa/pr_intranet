module Api::V1
  class HcQuestionsController < ApiController
    before_action :set_question, only: [:show]

    def show
      render json: @question, is_show: true, status: :ok
    end

    def importants
      questions = Helpcenter::Question.important_questions(@request_user)
      render json: questions, each_serializer: Helpcenter::QuestionSerializer, status: :ok
    end

    def search
      search = params[:search] || ""
      questions = Helpcenter::Question.where("name LIKE :search", search: "%#{search}%")
      render json: questions, each_serializer: Helpcenter::QuestionSerializer, status: :ok
    end

    private

    def show?
      return if @question.subcategory.category.profile_id.in?(@request_user.profile_ids)
      render json: { msg: "Not authorized", success: false }, status: :unauthorized
    end

    def set_question
      @question = Helpcenter::Question.find(params[:id])
      show?
    end
  end
end
