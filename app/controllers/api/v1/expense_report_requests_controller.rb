module Api::V1
  class ExpenseReportRequestsController < ApiController
    before_action :set_request, only: [:show]
    skip_before_action :set_current_user_from_header, only: [:review_request, :response_request]
    skip_before_action :verify_authenticity_token

    def index
      status = params[:status].downcase
      data = []
      if status == 'enviado' 
        status = 'en revisión'
      elsif status == 'aprobado'
        status = 'abierto'
      end
      if status == 'todos'
        requests = @request_user.requests.order(created_at: :desc)
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
      if params[:request][:id] != 'null'
        request = ExpenseReport::Request.find(params[:request][:id])
        request.update(request_params)
      else
        params[:request][:id] = ExpenseReport::Request.last.id + 1
        request = ExpenseReport::Request.new(request_params)
      end
      request.country_id = request.user.country
      request.request_state_id = ExpenseReport::RequestState.find_by(name: 'awaiting approval').id
      if request.save
        UserNotifierMailer.notification_new_request_boss(request).deliver # enviar correo al supervisor
        # UserNotifierMailer.notification_new_request_user(request).deliver # enviar correo al usuario
        # recorrer los requests para crear los invoice
        total_request = 0
        params[:invoice].permit!.to_h.each do |r|
          r[1][:total] = r[1][:total].gsub(/[\s,]/ ,"")
          if r[1][:id] == 'null'
            r[1][:id] = ExpenseReport::Invoice.last.id + 1
            invoice.request_id = request.id
            invoice = ExpenseReport::Invoice.create(r[1])
          else
            invoice = ExpenseReport::Invoice.find(r[1][:id])
            invoice.request_id = request.id
            invoice.update(r[1])
          end
          total_request += r[1][:total].to_f
        end
        request.update(total: total_request)
        render json: { message: "Request created", success: true }, status: :created
      else
        render json: { message: "Error", success: false }, status: :unprocessable_entity
      end
    end

    def review_request 
      approved_to_review = params[:approved_to_review].tr('=', '')
      # comprobar si el request esta expirado y enviar correos
      result = ExpenseReport::Request.request_boss_notifications(approved_to_review)
      invoices = []
      files = []
      result[:request].invoices.each do |i|
        i.files.each do |file|
          files << root_url + rails_blob_path(file, disposition: "attachment") 
        end
        invoices << {
          invoice: i,
          category: i.category.name,
          files: files
        }
      end
      if  result[:state] == "link_expired" || result[:request].request_state.name != 'awaiting approval'
        render json: { message: "Link expired", success: true, request: result[:request], user: result[:user],request_date: result[:request_date]}, status: :ok
      else
        render json: { message: "request", success: true, invoices: invoices ,request: result[:request], user: result[:user], request_date: result[:request_date] }, status: :ok
      end 
    end

    def response_request
      response = params[:request][0]
      request = ExpenseReport::Request.find(params[:request][1].to_i) 

      if response == 'true' && request.request_state.name == 'awaiting approval'
        request.update(request_state_id: ExpenseReport::RequestState.find_by(name: 'open').id)
        UserNotifierMailer.notification_new_request(request).deliver
        UserNotifierMailer.notification_request_approved_to_user(request).deliver
        UserNotifierMailer.notification_request_approved_to_boss(request).deliver
        render json: { message: "true" }, status: :ok
      elsif response == 'false' && request.request_state.name == 'awaiting approval'
        UserNotifierMailer.notification_request_rejected(request).deliver
        UserNotifierMailer.notification_request_rejected_to_boss(request).deliver
        request.destroy
        render json: { message: "false"}, status: :ok
      else 
        return
      end
    end

    def divisas
      data = ExpenseReport::Request::DIVISAS
      render json: data, status: :ok
    end

    def countries 
      data = ExpenseReport::Request::COUNTRY
      render json: data, status: :ok
    end

    def accounts
      data = @request_user.accounts.last.filtered_account
      render json: data, status: :ok
    end

    def payment_method
      data = ExpenseReport::Request::PAYMENT_METHOD
      render json: data, status: :ok
    end
    
    def update_draft_request
      request =  ExpenseReport::Request.find(request_params[:id])
      if request.update(request_params)
        total_request = 0
        params[:invoice].permit!.to_h.each do |r|
          r[1][:total] = r[1][:total].gsub(/[\s,]/ ,"")
          invoice = ExpenseReport::Invoice.where(id: r[1][:id]).first_or_create if r[1][:id] != 'null'
          if invoice.present? 
            invoice.update(r[1])
          else
            r[1][:id] = ExpenseReport::Invoice.last.id + 1 if r[1][:id] == 'null'
            invoice = ExpenseReport::Invoice.create(r[1])
          end
          invoice.update(request_id: request.id)
          total_request += r[1][:total].to_f
        end
        request.update(total: total_request)
        render json: { message: "Request Updated", success: true }, status: :created
      else
        render json: { message: "Error", success: false }, status: :unprocessable_entity
      end
    end

    def save_draft_request
      return update_draft_request if request_params[:id].present?
      request = ExpenseReport::Request.new(request_params)
      request.request_state_id = ExpenseReport::RequestState.find_by(name: 'draft').id
      if request.save
        # recorrer los requests para crear los invoice
        total_request = 0
        params[:invoice].permit!.to_h.each do |r|
          r[1][:id] = ExpenseReport::Invoice.last.id + 1 if r[1][:id] == 'null'
          r[1][:total] = r[1][:total].gsub(/[\s,]/ ,"")
          invoice = ExpenseReport::Invoice.create(r[1])
          invoice.update(request_id: request.id)
          total_request += r[1][:total].to_f
          request.update(total: total_request)
        end
        render json: { message: "Request created", success: true }, status: :created
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

    private 

    def set_data_request(requests)
      data = []
      requests.each do |request|
        status = ''
        if request.request_state.present?
          case request.request_state.code 
          when 'abierto'
            status='aprobado'
          when 'atendiendo'
            status='atendiendo'
          when 'en revisión'
            status='enviado'
          when 'resuelto'
            status='resuelto'
          when 'borrador'
            status='borrador'
          end
        else
          ''
        end

        data << {
          id: request.id,
          created_at: request.created_at.strftime('%d/%m/%Y %H:%M hrs'),
          status: status
        }
      end
      return data
    end

    def set_request
      @request = ExpenseReport::Request.find(params[:id])
    end

    def request_params
      params.require(:request).permit(:id, :category_id, :description, :user_id, :society_id, :divisa_id, :is_local, :destination_country_id, :bank_account_details, :payment_method_id, files: [])
    end
  end
end
  