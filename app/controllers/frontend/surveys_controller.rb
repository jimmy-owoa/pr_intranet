module Frontend
  class SurveysController < FrontendController
    def index
      data_surveys = []
      surveys_all = []
      surveys = Survey::Survey.includes(questions: :options)
      surveys.each do |survey|
        data_questions = []
        survey.questions.each do |question|
          data_options = []
          question.options.each do |option|
            data_options << {
              id: option.id,
              title: option.title,
              default: option.default,
              placeholder: option.placeholder
            }
          end
          data_questions << {
            id: question.id,
            title: question.title,
            question_type: question.question_type,
            optional: question.optional? ? false : true,
            options: data_options
          }
        end
        data_surveys << {
          id: survey.id,
          name: survey.name,
          once_by_user: survey.once_by_user,
          url: root_url + 'admin/surveys/' + "#{survey.id}" + '/edit',
          show_name: survey.show_name,
          description: survey.description,
          image: survey.image.attached? ?
          url_for(survey.image) : root_url + ActionController::Base.helpers.asset_url('survey.png'),
          created_at: survey.created_at.strftime('%d-%m-%Y'),
          questions: data_questions,
          survey_type: survey.survey_type,
          slug: survey.slug
        }
      end

      respond_to do |format|
        format.html
        format.json { render json: data_surveys }
        format.js
      end
    end

    def user_surveys
      user_id =  params[:id]
      data_surveys = []
      #model method
      no_once_by_user_surveys = Survey::Survey.where(once_by_user: false)
      surveys = Survey::Survey.survey_data(user_id)
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
              placeholder: option.placeholder
            }
          end
          data_questions << {
            id: question.id,
            title: question.title,
            question_type: question.question_type,
            optional: question.optional? ? false : true,
            options: data_options
          }
        end
        data_surveys << {
          id: survey.id,
          name: survey.name,
          once_by_user: survey.once_by_user,
          url: root_url + 'admin/surveys/' + "#{survey.id}" + '/edit',
          show_name: survey.show_name,
          description: survey.description,
          image: survey.image.attached? ?
          url_for(survey.image) : root_url + ActionController::Base.helpers.asset_url('survey.png'),
          created_at: survey.created_at.strftime('%d-%m-%Y'),
          questions: data_questions,
          survey_type: survey.survey_type,
          slug: survey.slug,
          inclusive_tags: survey.terms.inclusive_tags.map(&:name),
          excluding_tags: survey.terms.excluding_tags.map(&:name),
          categories: survey.terms.categories.map(&:name)
        }
      end
      #model method
      data = Survey::Survey.filter_surveys(user_id, data_surveys)
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
          format.html { redirect_to frontend_surveys_path, notice: 'Answer was successfully created.'}
          format.json { render :show, status: :created, location: @answer}
        else
          format.html {render :new}
          format.json {render json: @answer.errors, status: :unprocessable_entity}
        end
      end
    end

    def survey
      data = []
      slug = params[:slug].present? ? params[:slug] : nil
      survey = Survey::Survey.find_by_slug(slug)
      count = 0
      required = survey.questions.where(optional: true)
      if survey.once_by_user?
        required.each do |question|
          question.answers.each do |answer|
            if answer.user_id == 3
              count += 1
            end
          end
        end
      end
      if count != required.count
        data_survey = []
        data_questions = []
        survey.questions.each do |question|
          data_options = []
          question.options.each do |option|
            data_options << {
              id: option.id,
              title: option.title,
              default: option.default,
              placeholder: option.placeholder
            }
          end
          data_questions << {
            id: question.id,
            title: question.title,
            question_type: question.question_type,
            optional: question.optional? ? false : true,
            options: data_options
          }
        end
        data_survey << {
          id: survey.id,
          name: survey.name,
          once_by_user: survey.once_by_user,
          url: root_url + 'admin/surveys/' + "#{survey.id}" + '/edit',
          show_name: survey.show_name,
          description: survey.description,
          image: survey.image.attached? ?
          url_for(survey.image) : root_url + ActionController::Base.helpers.asset_url('survey.png'),
          created_at: survey.created_at.strftime('%d-%m-%Y'),
          questions: data_questions,
          survey_type: survey.survey_type,
          slug: survey.slug
        }
      else
        data_survey = ["Encuesta ya fué respondida por el usuario"]
      end
      respond_to do |format|
        format.html
        format.json { render json: data_survey[0] }
        format.js
      end
    end
      
    def survey_count
      data_user = []
      id = params[:id].present? ? params[:id] : nil
      @user = General::User.find(id)
      association = Survey::Question.includes(:answers)
      #si hay alguna pregunta sin ninguna respuesta, alerta
      if association.map{|a| a.answers.blank? }.include?(true)
        data_user << {alert: 1}
      elsif association.map{|a| a.answers.map(&:user_id).include?(@user.id) }.include?(false)
        data_user << {alert: 1}
      else
        data_user << {alert: 0}
      end
      respond_to do |format|
        format.json { render json: data_user[0] }
        format.js
      end
    end
  end
end
