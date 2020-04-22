module Frontend
  class SurveysController < FrontendController
    def index
      data_surveys = []
      surveys_all = []
      surveys = Survey::Survey.includes(questions: :options).where(profile_id: @request_user.profile_ids)
      surveys.each do |survey|
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
          url: root_url + "admin/surveys/" + "#{survey.id}" + "/edit",
          show_name: survey.show_name,
          description: survey.description,
          image: survey.image.attached? ?
            url_for(survey.image) : root_url + ActionController::Base.helpers.asset_url("survey.png"),
          created_at: survey.created_at.strftime("%d-%m-%Y"),
          questions: data_questions,
          survey_type: survey.survey_type,
          slug: survey.slug,
        }
      end

      respond_to do |format|
        format.html
        format.json { render json: data_surveys }
        format.js
      end
    end

    def user_surveys
      data_surveys = []
      if @request_user.has_role?(:super_admin) || @request_user.has_role?(:admin)
        respond_to do |format|
          format.html
          format.json { render json: Survey::Survey.published_surveys }
          format.js
        end
        return
      end
      #model method
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
          url: root_url + "admin/surveys/" + "#{survey.id}" + "/edit",
          show_name: survey.show_name,
          description: survey.description,
          image: survey.image.attached? ?
            url_for(survey.image) : root_url + ActionController::Base.helpers.asset_url("survey.png"),
          created_at: survey.created_at.strftime("%d-%m-%Y"),
          questions: data_questions,
          survey_type: survey.survey_type,
          slug: survey.slug,
        }
      end
      respond_to do |format|
        format.html
        format.json { render json: data_surveys }
        format.js
      end
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
      data = []
      slug = params[:slug].present? ? params[:slug] : nil
      survey = Survey::Survey.find_by_slug(slug)
      if survey.profile_id.in?(@request_user.profile_ids) || @request_user.has_role?(:super_admin) || @request_user.has_role?(:admin)
        options_user_ids = []
        survey.questions.each { |question| options_user_ids << question.answers.pluck(:user_id) }
        if (!@request_user.id.in?(options_user_ids) || !survey.once_by_user) || @request_user.has_role?(:super_admin) || @request_user.has_role?(:admin)
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
            url: root_url + "admin/surveys/" + "#{survey.id}" + "/edit",
            show_name: survey.show_name,
            description: survey.description,
            image: survey.image.attached? ?
              url_for(survey.image) : root_url + ActionController::Base.helpers.asset_url("survey.png"),
            created_at: survey.created_at.strftime("%d-%m-%Y"),
            questions: data_questions,
            survey_type: survey.survey_type,
            slug: survey.slug,
            status: survey.status,
            breadcrumbs: [
              { text: "Inicio", href: "/" },
              { text: "Encuestas", href: "/encuestas" },
              { text: survey.name.truncate(34), href: "/", disabled: true },
            ],
          }
        else
          data_survey = ["Encuesta ya fué respondida por el usuario"]
        end
        respond_to do |format|
          format.html
          format.json { render json: data_survey[0] }
          format.js
        end
      else
        respond_to do |format|
          format.html
          format.json { render json: "No tiene acceso" }
          format.js
        end
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
