module Api::V1
  class UsersController < ApiController
    include Rails.application.routes.url_helpers
    include ApplicationHelper
    skip_before_action :verify_authenticity_token, only: [:upload, :sign_in, :create_update, :destroy]
    skip_before_action :set_current_user_from_header, only: [:sign_in, :create_update, :destroy]
    before_action :set_user, only: [:create_update, :destroy]

    def create_log_report(endpoint, params, result, msg = nil, user = nil)
      today = Date.today.strftime("%Y_%m_%d")
      dir = File.dirname("#{Rails.root}/log/my_logs/#{today}.txt")
      FileUtils.mkdir_p(dir) unless File.directory?(dir)

      logger = Logger.new("#{Rails.root}/log/my_logs/#{today}.txt")
      logger.info("\n\n--------------------------------------------------------------\n")
      # logger = Logger.new("POST api_v1_users_create #{DateTime.now.to_s(:number)}.txt")
      logger.info("endpoint: #{endpoint}")
      logger.info("params: #{user_params}")
      logger.info("set_user_data_result: #{result}")
      logger.info("#{msg}")
      logger.info("user: #{user.to_json}")
    end

    def sign_in
      user_code = params[:user][:user_code]
      return handle_400 if user_code.blank?
      
      id_exa = InternalAuth.decrypt(user_code) rescue ""
      user = General::User.find_by(id_exa: id_exa)
      return handle_400 if user.blank?

      render json: { success: true, token: user.as_json_with_jwt[:token] }
    end

    def current_user_vue
      data = ActiveModelSerializers::SerializableResource.new(request_user, serializer: UserSerializer)
      render json: { user: data }, status: :ok
    end

    def create_update
      is_active = params[:active] == 'true' || params[:active] == true
      begin
        if !is_active
          user_active_false
        else
          @user.restore if @user.present? && @user.deleted_at.present? && is_active
          @user.present? ? update_user : create_user
        end
      rescue => exception
        render json: { message: exception }, status: :bad_request
      end
    end

    def update_user
      params[:email] = @user.email if params[:email].blank?
      set_cost_centers
      begin
        if @user.update(user_params)
          @user.touch(:updated_at)
          set_supervisor
          if @user.accounts.where(account_number: params[:payment_account][:account_number]).present?
            @user.accounts.where(account_number: params[:payment_account][:account_number]).first.update(payment_account)
          else
            @user.accounts.create(payment_account)
          end
          @user.update(society_id: General::Society.where(id_exa: params[:society][:society_id], name: params[:society][:name], country: params[:office_address]).first_or_create.id)
          Location::Country.set_office_country(@user, params[:office_address])
          create_log_report(request.url, user_params, nil, "Usuario actualizado!", @user)
          render json: { success: true, message: "User updated" }, status: :ok
        else
          create_log_report(request.url, user_params, nil, "Error!", @user.errors.full_messages)
          render json: { success: false, message: "Error"}, status: :unprocessable_entity
        end
      rescue => exception
        create_log_report(request.url, user_params, exception, "Error!", exception.message)
        render json: { message: "Error" }, status: :bad_request
      end
    end

    def create_user
      @user = General::User.new(user_params)
      @user.email = set_email if @user.email.blank?
      set_cost_centers
      begin
        if @user.save
          set_supervisor
          @user.accounts.create(payment_account)
          @user.update(society_id: General::Society.where(id_exa: params[:society][:society_id], name: params[:society][:name], country: params[:office_address]).first_or_create.id)
          Location::Country.set_office_country(@user, params[:office_address])
          create_log_report(request.url, user_params, nil, "Usuario creado!", @user)
          render json: {  success: true, message: "User created" }, status: :created
        else
          create_log_report(request.url, user_params, nil, "Error!", @user.errors.full_messages)
          render json: { success: false, message: "Error"}, status: :unprocessable_entity
        end
      rescue => exception
        create_log_report(request.url, user_params, exception, "Error!", exception.message)
        render json: { message: exception }, status: :bad_request
      end
    end

    def set_email
      email = "#{((0...8).map { (65 + rand(26)).chr }.join).downcase}@compass.cl"
      if General::User.find_by(email: email).present?
        set_email
      end
      email
    end

    def destroy
      begin
        @user.destroy
        create_log_report(request.url, user_params, nil, "Usuario eliminado!", @user)
        render json: { success: true, message: "User deleted" }, status: :ok
      rescue => exception
        create_log_report(request.url, user_params, exception, "Error!", exception.message)
        render json: { success: false, message: "Error" }, status: :unprocessable_entity
      end
    end

    def search
      if params[:search].present? && params[:search].length > 2
        users = General::User.users_for_search.search(params[:search]).order(:name, :last_name, :last_name2)
        results = users.map {|u| { id: u.id, name: u.name + " " + u.last_name + " " + u.last_name2, society: u.society_id, email: u.email,legal_number: u.legal_number, country: u.country.name, supervisor: u.get_supervisor_full_name, accounts: u.accounts.last.try(:filtered_account)}}
        render json: { success: true, users: results }, status: :ok
      else
        render json: { success: false, message: "Error" }, status: :unprocessable_entity
      end
    end

    def set_cost_centers
      if params[:cost_centers].present?
        user_cost_centers = []
        params[:cost_centers].each do |cost_center|
          temp_cc = Company::CostCenter.where(name: cost_center[:name], dependence: cost_center[:dependence]).first_or_create
          user_cost_centers << General::CostCenterUser.where(percentage: cost_center[:percentage], cost_center_id: temp_cc.id ).first_or_create
        end
        @user.cost_center_users = user_cost_centers
      end
    end
    
    private

    def user_active_false
      if @user.present?
        if !@user.deleted?
          destroy
        else  
          render json: { message: "User deleted" }, status: :ok
        end
      else
        render json: { message: "User not created" }, status: :ok
      end
    end

    def set_user
      begin
        id_exa = InternalAuth.decrypt(params[:user_code_crypted_base64])
        @user = General::User.with_deleted.find_by(id_exa: id_exa)
      rescue => error
        create_log_report(request.url, params, error, "Error!", "Error en find_user")
        render json: { success: false, error: "Error" }, status: :unauthorized
      end
    end

    def set_supervisor
      supervisor = General::User.where(id_exa: @user.supervisor).last
      supervisor.update(is_boss: true) if supervisor.present?
    end

    def user_params
      params.permit(
        :id_exa, :legal_number, :name, :last_name,
        :last_name2, :email, :office_addres, :position, :id_exa_boss, :supervisor, :cost_centers
      )
    end
    def payment_account 
      params.require(:payment_account).permit(:name, :account_number, :email, :legal_number, :bank_name, :account_type, :country)
    end
  end
end
