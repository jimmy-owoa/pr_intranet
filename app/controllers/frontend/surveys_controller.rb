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
            optional: question.optional,
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
      surveys = Survey::Survey.survey_data(user_id)
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
            optional: question.optional,
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
          inclusive_tags: survey.terms.inclusive_tags.map(&:name).sort_by!{ |e| e.downcase },
          excluding_tags: survey.terms.excluding_tags.map(&:name).sort_by!{ |e| e.downcase }
        }
      end
      #model method
      data = Survey::Survey.filter_surveys(user_id, data_surveys)
      respond_to do |format|
        format.html
        format.json { render json: data }
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
            optional: question.optional,
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
      if Survey::Question.includes(:answers).map{|a| a.answers.blank? }.include?(true)
        data_user << {alert: 1}
      elsif Survey::Question.includes(:answers).map{|a| a.answers.where(user_id: @user.id)}.flatten.count != 0
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
