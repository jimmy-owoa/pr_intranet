module Api::V1
  class SurveysController < ApiController
    def index
      surveys = Survey::Survey.get_surveys(@request_user)
      render json: surveys, each_serializer: SurveySerializer, status: :ok
    end

    def user_surveys
      data_surveys = []
      no_once_by_user_surveys = Survey::Survey.get_surveys_no_once_user(@request_user)
      surveys = Survey::Survey.survey_data(@request_user)
      surveys << no_once_by_user_surveys
      surveys.flatten.each do |survey|
        data_questions = []
        survey.questions.each do |question|
          data_options = []
          question.options.each do |option|
            data_options << {
              id: option.id,
              title: option.title,
              default: option.default,
              placeholder: option.placeholder,
            }
          end
          data_questions << {
            id: question.id,
            title: question.title,
            question_type: question.question_type,
            optional: question.optional? ? false : true,
            options: data_options,
          }
        end
        data_surveys << {
          id: survey.id,
          name: survey.name,
          once_by_user: survey.once_by_user,
          # url: root_url + "admin/surveys/" + "#{survey.id}" + "/edit",
          show_name: survey.show_name,
          description: survey.description,
          image: survey.image.attached? ?
            url_for(survey.image) : ActionController::Base.helpers.asset_path("survey.png"),
          created_at: survey.created_at.strftime("%d-%m-%Y"),
          questions: data_questions,
          survey_type: survey.survey_type,
          slug: survey.slug,
        }
      end
      data = { status: "ok", results_length: data_surveys.count, surveys: data_surveys }
      render json: data, status: :ok
    end

    def create
      @answer = Survey::Answer.new(answer_params)
      respond_to do |format|
        if @answer.save
          format.html { redirect_to frontend_surveys_path, notice: "Answer was successfully created." }
          format.json { render :show, status: :created, location: @answer }
        else
          format.html { render :new }
          format.json { render json: @answer.errors, status: :unprocessable_entity }
        end
      end
    end

    def survey
      slug = params[:slug].present? ? params[:slug] : nil
      survey = Survey::Survey.find_by_slug(slug)
      if survey.profile_id.in?(@request_user.profile_ids) || @request_user.has_role?(:super_admin) || @request_user.has_role?(:admin)
        options_user_ids = []
        survey.questions.each { |question| options_user_ids << question.answers.pluck(:user_id) }
        if (!@request_user.id.in?(options_user_ids.flatten) || !survey.once_by_user) || @request_user.has_role?(:super_admin) || @request_user.has_role?(:admin)
          if survey.answered_times.count < survey.allowed_answers || survey.allowed_answers == 0
            data_survey = []
            data_questions = []
            survey.questions.each do |question|
              data_options = []
              question.options.each do |option|
                data_options << {
                  id: option.id,
                  title: option.title,
                  default: option.default,
                  placeholder: option.placeholder,
                }
              end
              data_questions << {
                id: question.id,
                title: question.title,
                question_type: question.question_type,
                optional: question.optional? ? false : true,
                options: data_options,
              }
            end
            data_survey << {
              id: survey.id,
              name: survey.name,
              once_by_user: survey.once_by_user,
              # url: root_url + "admin/surveys/" + "#{survey.id}" + "/edit",
              show_name: survey.show_name,
              description: survey.description,
              image: survey.image.attached? ?
                url_for(survey.image) : ActionController::Base.helpers.asset_path("survey.png"),
              created_at: survey.created_at.strftime("%d-%m-%Y"),
              questions: data_questions,
              survey_type: survey.survey_type,
              slug: survey.slug,
              status: survey.status,
            }
          else
            data_survey = [""]
          end
          data_survey << {
            id: survey.id,
            name: survey.name,
            once_by_user: survey.once_by_user,
            # url: root_url + "admin/surveys/" + "#{survey.id}" + "/edit",
            show_name: survey.show_name,
            description: survey.description,
            image: survey.image.attached? ?
              url_for(survey.image) : ActionController::Base.helpers.asset_path("survey.png"),
            created_at: survey.created_at.strftime("%d-%m-%Y"),
            questions: data_questions,
            survey_type: survey.survey_type,
            slug: survey.slug,
            status: survey.status,
          }
        else
          data_survey = [""]
        end
        breadcrumbs = [
          { text: "Inicio", href: "/" },
          { text: "Encuestas", href: "/encuestas" },
          { text: survey.name.truncate(30), disabled: true },
        ]
        data = { status: "ok", slug: slug, breadcrumbs: breadcrumbs, survey: data_survey[0]}
        render json: data, status: :ok
      else
        render json: { status: "error", message: "no tiene acceso" }
      end
    end

    def survey_count
      data_user = []
      association = Survey::Question.includes(:answers)
      #si hay alguna pregunta sin ninguna respuesta, alerta
      if association.map { |a| a.answers.blank? }.include?(true)
        data_user << { alert: 1 }
      elsif association.map { |a| a.answers.map(&:ln_user).include?(@request_user.id) }.include?(false)
        data_user << { alert: 1 }
      else
        data_user << { alert: 0 }
      end
      respond_to do |format|
        format.json { render json: data_user[0] }
        format.js
      end
    end
  end
end
