class Frontend::BirthsController < ApplicationController
  #callbacks
  before_action :set_birth, only: [:show, :destroy]
  after_action :set_tracking, only: [:index, :show, :new, :list]
  after_action :set_tracking_action, only: [:create]  

    def index
      births = Employee::Birth.show_birth.birthday_between(1.year.ago, Time.now)
      births_calendar = Employee::Birth.show_birth
      data = []
      births.each do |birth|
        data << {
          id: birth.id,
          child_full_name: birth.child_name + ' ' + birth.child_lastname,
          photo: @ip.to_s + rails_representation_url(birth.photo.variant(resize: '600x600'), only_path: true),
          gender: birth.gender ? 'Masculino' : 'Femenino',
          created_at: birth.created_at.strftime("%d/%m/%Y %H:%M"),
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

    def get_home_births
      data = []
      births = Employee::Birth.show_birth.last(4)
      births.each do |birth|
        data << {
          id: birth.id,
          child_full_name: birth.child_name + ' ' + birth.child_lastname,
          photo: @ip.to_s + rails_representation_url(birth.photo.variant(resize: '600x600'), only_path: true),
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

    def new
      add_breadcrumb "Nacimientos", :frontend_births_path
      @birth = Employee::Birth.new
    end

    def show 

    end

    def create
      @birth = Employee::Birth.new(birth_params)
      respond_to do |format|
        if @birth.save
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
