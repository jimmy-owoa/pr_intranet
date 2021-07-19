module Api::V1
  class SurveysController < ApiController
    before_action :set_survey, only: [:show]
    before_action :check_survey, only: [:show]
    before_action :check_user, only: [:show]

    def index
      surveys = Survey::Survey.get_surveys(@request_user)
      render json: surveys, each_serializer: SurveySerializer, status: :ok
    end

    def show
      if @survey.show_to?(@request_user)
        render json: @survey, serializer: SurveySerializer, is_show: true, status: :ok
      else
        render json: { success: false, message: "bad request" }, status: :bad_request
      end
    end

    def check_user
      if !@survey.profile_id.in?(@request_user.profile_ids) && !@request_user.has_role?(:admin)
        return render json: { success: false, message: "Error" }, status: :unauthorized
      end
    end

    def check_survey
      return record_not_found if @survey.nil?
    end

    private

    def set_survey
      @survey = Survey::Survey.find_by_slug(params[:slug])
    end
  end
end
