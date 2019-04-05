require 'base64'
require 'stringio'
module Frontend
  class BirthsController < FrontendController
  #callbacks
  layout 'admin'
  before_action :set_birth, only: [:show, :destroy]
  after_action :set_tracking, only: [:index, :show, :new, :list]

    def index
      births = Employee::Birth.show_birth.birt_between(1.month.ago, Time.now) #se cambio de un año a un mes
      births_calendar = Employee::Birth.show_birth
      data = []
      births.each do |birth|   
        images = []
        birth.permitted_images.map{|image| images << url_for(image.variant(resize: '500x500>'))}
        data << {
          id: birth.id,
          child_full_name: birth.child_name + ' ' + birth.child_lastname,
          photo: birth.permitted_images.present? ? url_for(birth.images.attachments.first.variant(resize: '500x500>')) : root_url + '/assets/birth.png',
          images: images,
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
        images = []
        birth.permitted_images.map{|image| images << url_for(image.variant(resize: '500x500>'))}
        data << {
          id: birth.id,
          child_full_name: birth.child_name + ' ' + birth.child_lastname,
          photo: birth.permitted_images.present? ? url_for(birth.images.attachments.first.variant(resize: '500x500>')) : root_url + '/assets/birth.png',
          images: images,
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
          photo: url_for(birth.images.attachments.first.variant(resize: '500x500>')),
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
        if images.present? 
          images.each do |image|
            base64_image = image[1].sub(/^data:.*,/, '')
            decoded_image = Base64.decode64(base64_image)
            image_io = StringIO.new(decoded_image)
            @birth_image = { io: image_io, filename: child_name }  
            @birth.images.attach(@birth_image)
          end
        end
      respond_to do |format|
        if @birth.save
          format.html { redirect_to frontend_birth_path(@birth), notice: 'Birth was successfully created.'}
          format.json { render json: @birth, status: 200}
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
end
