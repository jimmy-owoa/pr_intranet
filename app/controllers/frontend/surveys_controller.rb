module Frontend
  class SurveysController < FrontendController
    def index
      data_surveys = []
      surveys_all = []
      surveys = Survey::Survey.includes(questions: :options)
      # query_1 = Survey::Survey.includes(questions: :answers).where(once_by_user: true).where.not("survey_answers.user_id" => 3)
      # query_2 = Survey::Survey.includes(questions: :answers).where(once_by_user: false)
      #queries
      # surveys_all << query_1 if query_1.present?
      # surveys_all << query_2 if query_2.present?
      #######
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
          slug: survey.slug
        }
      end

      respond_to do |format|
        format.html
        format.json { render json: data_surveys }
        format.js
      end
    end

    def filter_surveys id
      user = General::User.find(id)
      user_tags = user.terms.tags.map(&:name)
      surveys = []
      Survey::Survey.all.each do |survey| 
        survey.terms.tags.each do |tag|
          surveys.push(survey) if tag.name.in?(user_tags)
        end
      end
      posts
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
