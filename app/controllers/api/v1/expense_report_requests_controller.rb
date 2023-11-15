module Api::V1
  class ExpenseReportRequestsController < ApiController
    before_action :set_request, only: [:show, :update, :destroy]
    skip_before_action :set_current_user_from_header, only: [:review_request, :response_request]
    skip_before_action :verify_authenticity_token
    include ActionView::Helpers::DateHelper

    def index
      status = params[:status].downcase
      data = []
      if status == 'todos'
        requests = ExpenseReport::Request.where('user_id = :user_id OR created_by_id = :user_id', user_id: @request_user.id).order(created_at: :desc)
      else
        id_status = ExpenseReport::RequestState.find_by(code: status).id
        requests = @request_user.requests.where(request_state_id: id_status ).order(created_at: :desc)
      end
      data = set_data_request(requests)
      render json: data, status: :ok
    end

    def show
      render json: @request, serializer: ExpenseReport::RequestSerializer, is_show: true, status: :ok
    end

    def create
      request = ExpenseReport::Request.new(request_params)
      request.created_by = @request_user
      request.destination_country_id = params[:request][:destination_country_id].to_i  if params[:request][:destination_country_id] != 'NULL'
      request.set_state(params[:request][:request_state])
      request.country_id = request.user.country.id
      if request.save
        request.request_histories.create(user_id: request.user_id, request_state_id: request.request_state_id)
        UserNotifierMailer.notification_new_request_boss(request).deliver if request.request_state.name == 'envoy'
        UserNotifierMailer.notification_new_request_user(request).deliver # enviar correo al usuario
        UserNotifierMailer.notification_to_the_third_party(request, @request_user).deliver if @request_user != request.user # enviar correo al tercero
        # recorrer los requests para crear los invoice
        total_request = 0
        params[:invoice].permit!.to_h.each do |r|
          r[1][:total] = r[1][:total].gsub(/[\s,]/ ,"")
            request.invoices.create(r[1])
          total_request += r[1][:total].to_f
        end
        request.update(total: total_request)
        if(request.request_state.name == 'draft')
          render json: request.id, status: :ok
        else
          render json: { message: "Request created", success: true }, status: :created
        end
      else
        render json: { message: "Error", success: false }, status: :unprocessable_entity
      end
    end

    def review_request
      approved_to_review = params[:approved_to_review].tr('=', '')
      # comprobar si el request esta expirado y enviar correos
      result = ExpenseReport::Request.request_boss_notifications(approved_to_review)
      invoices = []
      request_files = []
      request_state = result[:request].request_state.code
      boss_id = result[:user].id_exa_boss
      pending_requests = data_pending_requests(boss_id)
      pending_requests.reject! { |request| request[:id] == result[:request].id }
      result[:request].files.each_with_index do |f, index|
        request_files << {id: index + 1, url: root_url + rails_blob_path(f, disposition: "attachment")}
      end
      result[:request].invoices.each do |i|
        files = []
        i.files.each do |file|
          files << root_url + rails_blob_path(file, disposition: "attachment")
        end
        invoices << {
          invoice: i,
          category: i.category.name,
          files: files
        }
      end
      if  result[:state] == "link_expired"
        render json: { message: "Link expired", success: true, request: result[:request], user: result[:user], request_date: result[:request_date]}, status: :ok
      else
        render json: { message: "request", request_state: request_state, success: true,files: request_files, invoices: invoices ,request: result[:request], requests: pending_requests, user: result[:user], request_date: result[:request_date] }, status: :ok
      end 
    end

    def data_pending_requests(boss_id)
      pending_requests_to_approve = General::User.find_by(id_exa_boss: boss_id).requests.where(request_state_id: 6)
      key = Rails.application.credentials[:secret_key_base][0..31]
      crypt = ActiveSupport::MessageEncryptor.new(key)
      data = []
      pending_requests_to_approve.each do |r|
        @encrypted_data = Base64.strict_encode64(crypt.encrypt_and_sign({id: r.id}))
        @link_index = "https://ayudacompass.redexa.cl/rendicion-gastos/review/#{@encrypted_data }"
        data << {
          id: r.id,
          user_name: r.user.try(:full_name),
          created_at: r.created_at,
          link: @link_index
        }
      end
      return data 
    end
    
    def request_draft
      request = ExpenseReport::Request.find(params[:id])
      if request.request_state.name == 'draft' || 'envoy'
        render json: request, serializer: ExpenseReport::RequestSerializer, is_show: true, status: :ok
      else
        render json: { message: "false"}, status: :ok
      end
    end

    def destroy
      if @request.destroy
        render json: { message: "Request Destroy", success: true }, status: :ok
      else
        render json: { message: "Error", success: false }, status: :unprocessable_entity
      end
    end

    def response_request
      response = params[:request][0]
      request = ExpenseReport::Request.find(params[:request][1].to_i)
      if response == 'true' && request.request_state.name == 'envoy'
        request.update(request_state_id: ExpenseReport::RequestState.find_by(name: 'approved').id)
        UserNotifierMailer.notification_new_request(request).deliver if request.country.assistants.map(&:email).present?
        UserNotifierMailer.notification_request_approved_to_user(request).deliver
        UserNotifierMailer.notification_request_approved_to_boss(request).deliver
        request.request_histories.create(user_id: request.user.get_supervisor.id, request_state_id: request.request_state_id)
        render json: { message: "true" }, status: :ok
      elsif response == 'false' && request.request_state.name == 'envoy'
        UserNotifierMailer.notification_request_rejected(request).deliver
        UserNotifierMailer.notification_request_rejected_to_boss(request).deliver
        rejected_id = ExpenseReport::RequestState.where(code: 'rechazado').last.id
        request.request_histories.create(user_id: request.user.get_supervisor.id, request_state_id: rejected_id)
        request.update(request_state_id: rejected_id)
        request.destroy
        render json: { message: "false"}, status: :ok
      else 
        return
      end
    end

    def divisas
      country_name = @request_user.country.name
      data =  ExpenseReport::Request::CURRENCY_BY_COUNTRY[country_name] || ExpenseReport::Request::DIVISAS
      render json: data, status: :ok
    end

    def countries 
      data = ExpenseReport::Request::COUNTRY
      render json: data, status: :ok
    end

    def accounts
      begin
        user = General::User.find(params[:user_id])
        data = user.accounts.last.try(:filtered_account)
        render json: data, status: :ok
      rescue => error 
        render json: error, status: :unprocessable_entity
      end
    end

    def payment_method
      country = @request_user.country.name

       data = case country
              when 'ARGENTINA'
                ExpenseReport::Request::PAYMENT_METHOD.select do |method|
                  [:'Transferencia bancaria moneda local', :'Transferencia bancaria moneda extranjera', :'Pago tarjeta corporativa'].include?(method.keys.first)
                end
              when 'BRASIL'
                ExpenseReport::Request::PAYMENT_METHOD.select do |method|
                  [:'Transferencia bancaria moneda local', :'Transferencia bancaria moneda extranjera'].include?(method.keys.first)
                end
              when 'CHILE'
                ExpenseReport::Request::PAYMENT_METHOD.select do |method|
                  [:'Transferencia bancaria moneda local', :'Transferencia bancaria moneda extranjera', :'Abono tarjeta de crédito'].include?(method.keys.first)
                end
              when 'MEXICO'
                ExpenseReport::Request::PAYMENT_METHOD.select do |method|
                  [:'Transferencia bancaria moneda local', :'Transferencia bancaria moneda extranjera', :'Pago tarjeta corporativa'].include?(method.keys.first)
                end
              when 'PERU'
                ExpenseReport::Request::PAYMENT_METHOD.select do |method|
                  [:'Transferencia bancaria moneda local', :'Transferencia bancaria moneda extranjera'].include?(method.keys.first)
                end
              when 'URUGUAY'
                ExpenseReport::Request::PAYMENT_METHOD.select do |method|
                  [:'Transferencia bancaria moneda local', :'Transferencia bancaria moneda extranjera', :'Pago tarjeta corporativa'].include?(method.keys.first)
                end
              when 'NUEVA YORK'
                ExpenseReport::Request::PAYMENT_METHOD.select do |method|
                  [:'Transferencia bancaria moneda local'].include?(method.keys.first)
                end
              when 'MIAMI'
                ExpenseReport::Request::PAYMENT_METHOD.select do |method|
                  [:'Transferencia bancaria moneda local'].include?(method.keys.first)
                end
              else
                ExpenseReport::Request::PAYMENT_METHOD
              end
      render json: data, status: :ok
    end

    def request_user
      @user = {
        id: @request_user.id,
        email: @request_user.try(:email),
        country: @request_user&.country&.name,
        full_name: @request_user.get_full_name,
        id_exa_boss: General::User.where(id_exa: @request_user.id_exa_boss).last.try(:full_name),
        last_name: @request_user.try(:last_name),
        legal_number: @request_user.try(:legal_number),
        name: @request_user.try(:name),
        society: @request_user.try(:society).id,
        supervisor: @request_user.get_supervisor_full_name,
        accounts: @request_user.accounts.last.try(:filtered_account)
      }
      render json: @user, status: :ok
    end
    
    def update
      @request.set_state(params[:request][:request_state])
      @request.destination_country_id =  params[:request][:destination_country_id].to_i
      params[:request][:destination_country_id] == 'NULL' ? @request.destination_country_id = nil : @request.destination_country_id = params[:request][:destination_country_id].to_i 
      if @request.update(request_params)
        UserNotifierMailer.notification_new_request_boss(@request).deliver if @request.request_state.name == 'envoy'
        total_request = 0
        params[:invoice].permit!.to_h.each do |r|
          r[1][:total] = r[1][:total].gsub(/[\s,]/ ,"")
          invoice = ExpenseReport::Invoice.find_by(id: r[1][:id]) if r[1][:id].present?
          if invoice.present? 
            invoice.update(r[1])
          else
            @request.invoices.create(r[1])
          end
          total_request += r[1][:total].to_f
        end
        @request.update(total: total_request)
        if @request.request_state.name == 'draft'
          render json: @request.id, status: :ok
        else
          render json: { message: "Request updated", success: true }, status: :ok
        end
      else
        render json: { message: "Error", success: false }, status: :unprocessable_entity
      end
    end

    def destroy_file
      file = ActiveStorage::Attachment.find(params[:id])
      if file.destroy
        render json: { message: "File Destroy", success: true }, status: :ok
      else
        render json: { message: "Error", success: false }, status: :unprocessable_entity
      end
    end

    def destroy_invoice
      invoice = ExpenseReport::Invoice.find(params[:id])
      if invoice.destroy
        render json: { message: "Invoice Destroy", success: true }, status: :ok
      else
        render json: { message: "Error", success: false }, status: :unprocessable_entity
      end
    end

    def pending_requests
      pending_requests = ExpenseReport::Request.with_deleted.includes(:user).where(general_users: { supervisor: @request_user.id_exa }).order(created_at: :desc)
      pending_requests = pending_requests.includes(:request_state).where.not(expense_report_request_states: {name: ['draft', 'delete']})

      if params[:status] != 'Todos'
        pending_requests =  pending_requests.includes(:request_state).where(expense_report_request_states: {code: params[:status].downcase})
      end
      data = []
      pending_requests.each do |request|
        link = generate_link_supervisor(request)

        data << {
          id: request.id,
          created_at: request.created_at.strftime('%d/%m/%Y %H:%M hrs'),
          status: request.request_state.code,
          url: link
        }
      end
      render json: data, status: :ok
    end

    private 

    def set_data_request(requests)
      data = []
      requests.each do |request|
        data << {
          id: request.id,
          created_at: request.created_at.strftime('%d/%m/%Y %H:%M hrs'),
          status: request.request_state.code,
          for_other: request.user != @request_user
        }
      end
      return data
    end

    def set_request
      @request = ExpenseReport::Request.find(params[:id])
    end

    def request_params
      params.require(:request).permit(:id, :category_id, :description, :user_id, :society_id, :divisa_id, :is_local, :bank_account_details, :payment_method_id, files: [])
    end

    def generate_link_supervisor(request)
      #encrypt
      key = Rails.application.credentials[:secret_key_base][0..31]
      crypt = ActiveSupport::MessageEncryptor.new(key)
      @encrypted_data = Base64.strict_encode64(crypt.encrypt_and_sign({id: request.id}))
      @link_index = "https://ayudacompass.redexa.cl/rendicion-gastos/review/#{@encrypted_data }"
    end
  end
end
  