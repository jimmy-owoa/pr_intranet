require 'base64'
require 'stringio'
module Frontend
  class BirthsController < FrontendController
    #callbacks
    layout 'admin'
    before_action :set_birth, only: [:show, :destroy]
    after_action :set_tracking, only: [:index, :show, :new, :list]

    def index
      page = params[:page]
      date = params[:date]
      all_births = Employee::Birth.show_birth.where('extract(month from birthday) = ?', date) #se cambio de un año a un mes
      births = Kaminari.paginate_array(all_births).page(page).per(9)
      data = []
      births.each do |birth|   
        birth_father = General::User.where("CONCAT(name,' ',last_name,' ',last_name2) = ?", birth.full_name_father).first
        birth_mother = General::User.where("CONCAT(name,' ',last_name,' ',last_name2) = ?", birth.full_name_mother).first
        email = 
        if birth_father.present?
           birth_father.email
        elsif birth_mother.present?
          birth_mother.email
        else
          'sin email'
        end 
        images = []
        birth.permitted_images.map{|image| images << url_for(image.variant(resize: '500x500>'))}
        data << {
          id: birth.id,
          name: birth.child_name,
          last_names: birth.child_lastname + ' ' + birth.child_lastname2,
          photo: birth.permitted_images.present? ? url_for(birth.images.attachments.first.variant(resize: '500x500>')) : root_url + ActionController::Base.helpers.asset_url('birth.png'),
          images: images,
          gender: birth.gender,
          birthday: l(birth.birthday, format: "%d de %B").downcase,
          father: birth.full_name_father,
          mother: birth.full_name_mother,
          email: email,
        }
      end
      respond_to do |format|
        format.html
        format.json { render json: {hits: data} }
        format.js
      end
    end

    def get_home_births
      data = []
      births = Employee::Birth.show_birth.order(birthday: :asc).last(4)
      births.each do |birth|
        images = []
        birth.permitted_images.map{|image| images << url_for(image.variant(resize: '500x500>'))}
        data << {
          id: birth.id,
          child_full_name: birth.child_name + ' ' + birth.child_lastname + ' ' + birth.child_lastname2,
          photo: birth.permitted_images.present? ? url_for(birth.images.attachments.first.variant(resize: '500x500>')) : root_url + ActionController::Base.helpers.asset_url('birth.png'),
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
      births = Employee::Birth.show_birth.births_between(1.year.ago, Time.now)
      data = []
      births.each do |birth|
        data << {
          id: birth.id,
          child_full_name: birth.child_name + ' ' + birth.child_lastname + ' ' + birth.child_lastname2,
          photo: birth.images.attachments.present? ? url_for(birth.images.attachments.first.variant(resize: '500x500>')) : root_url + ActionController::Base.helpers.asset_url('birth.png'),
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
      child_lastname2 = params[:child_lastname2]
      full_name_father = params[:full_name_father]
      full_name_mother = params[:full_name_mother]
      is_public = params[:is_public]
      approved = params[:approved]
      gender = params[:gender]
      birthday = params[:birthday]
      images = params[:images]
      user_id = params[:user_id]
      @birth = Employee::Birth.new(child_name: child_name, child_lastname: child_lastname, 
        child_lastname2: child_lastname2, full_name_father: full_name_father, full_name_mother: full_name_mother,
        approved: approved, gender: gender, birthday: birthday, is_public: is_public, user_id: user_id)
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
      params.require(:birth).permit(:full_name_mother, :full_name_father, :is_public, :child_name, :child_lastname,
      :child_lastname2, :birthday, :photo, :approved, :gender)
    end
    
  end
end
