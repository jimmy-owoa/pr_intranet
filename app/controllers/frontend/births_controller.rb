class Frontend::BirthsController < ApplicationController
  #callbacks
  layout 'admin'
  before_action :set_birth, only: [:show, :destroy]
  after_action :set_tracking, only: [:index, :show, :new, :list]
  after_action :set_tracking_action, only: [:create]  

    def index
      births = Employee::Birth.show_birth.birt_between(1.month.ago, Time.now) #se cambio de un año a un mes
      births_calendar = Employee::Birth.show_birth
      data = []
      births.each do |birth|
        data << {
          id: birth.id,
          child_full_name: birth.child_name + ' ' + birth.child_lastname,
          photo: url_for(birth.photo.variant(resize: '500x500>')),
          gender: birth.gender ? 'Masculino' : 'Femenino',
          created_at: birth.created_at.strftime("%d/%m/%Y %H:%M"),
          birthday: birth.birthday,
          father: birth.full_name_father,
          mother: birth.full_name_mother,
          breadcrumbs: [
              {link: '/', name: 'Inicio' },
              {link: '/nacimientos', name: 'Nacimientos' },
              {link: '#', name: birth.child_fullname.truncate(30)}
            ]
        }
      end
      respond_to do |format|
        format.html
        format.json { render json: data }
        format.js
      end
    end

    def get_home_births
      data = []
      births = Employee::Birth.show_birth.last(4)
      births.each do |birth|
        data << {
          id: birth.id,
          child_full_name: birth.child_name + ' ' + birth.child_lastname,
          photo: url_for(birth.photo.variant(resize: '500x500>')),
          gender: birth.gender ? 'Masculino' : 'Femenino',
          birthday: birth.birthday,
          father: birth.full_name_father,
          mother: birth.full_name_mother
        }
      end
      respond_to do |format|
        format.html
        format.json { render json: data }
        format.js
      end
    end

    def calendar_births
      births = Employee::Birth.show_birth.birt_between(3.month.ago, -3.month.ago)
      data = []
      births.each do |birth|
        data << {
          id: birth.id,
          child_full_name: birth.child_name + ' ' + birth.child_lastname,
          photo: url_for(birth.photo.variant(resize: '600x600')),
          gender: birth.gender ? 'Masculino' : 'Femenino',
          date: birth.birthday,
          father: birth.full_name_father,
          mother: birth.full_name_mother
        }
      end
      respond_to do |format|
        format.html
        format.json { render json: data.flatten }
        format.js
      end
    end    

    def new
      add_breadcrumb "Nacimientos", :frontend_births_path
      @birth = Employee::Birth.new
    end

    def show
    end

    def create
      child_name = params[:child_name]
      child_lastname = params[:child_lastname]
      full_name_father = params[:full_name_father]
      full_name_mother = params[:full_name_mother]
      approved = params[:approved]
      gender = params[:gender]
      birthday = params[:birthday]
      images = params[:images]

      @birth = Employee::Birth.new(child_name: child_name, child_lastname: child_lastname, 
        full_name_father: full_name_father, full_name_mother: full_name_mother, approved: approved,
        gender: gender, birthday: birthday)
        images.each do |image|
          @birth.images.attach(io: File.open(image[1].tempfile), filename: image[1].original_filename, content_type: image[1].content_type)
        end
      respond_to do |format|
        if @birth.save
          # @birth.images.attach(params[:images])
          format.html { redirect_to frontend_birth_path(@birth), notice: 'Birth was successfully created.'}
          format.json { render :show, status: :created, location: @birth}
        else
          format.html {render :new}
          format.json {render json: @birth.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @birth.destroy
      respond_to do |format|
        format.html { redirect_to admin_births_path, notice: 'Birth was successfully destroyed.'}
        format.json { head :no_content }
      end
    end

  private

    def set_tracking
      ahoy.track "Birth Model", params
    end

    def set_tracking_action
      ahoy.track "Birth Model / Actions", controller: params[:controller], action: params[:action], user: params[:user][:email]
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_birth
      @birth = Employee::Birth.find(params[:id])
    end

    def birth_params
      params.require(:birth).permit(:full_name_mother, :full_name_father, :child_name, :child_lastname,
      :birthday, :photo, :approved, :gender)
    end
  end
