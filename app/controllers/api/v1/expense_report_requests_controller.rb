module Api::V1
  class ExpenseReportRequestsController < ApiController
    before_action :set_request, only: [:show, :update]
    skip_before_action :set_current_user_from_header, only: [:review_request, :response_request]
    skip_before_action :verify_authenticity_token

    def index
      status = params[:status].downcase
      data = []
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
      request = ExpenseReport::Request.new(request_params)
      request.set_state(params[:request][:request_state])
      request.country_id = request.user.country.id
      if request.save
        UserNotifierMailer.notification_new_request_boss(request).deliver if request.request_state.name == 'envoy'
        # UserNotifierMailer.notification_new_request_user(request).deliver # enviar correo al usuario
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
      if  result[:state] == "link_expired" || result[:request].request_state.name != 'envoy'
        render json: { message: "Link expired", success: true, request: result[:request], user: result[:user],request_date: result[:request_date]}, status: :ok
      else
        render json: { message: "request", success: true, invoices: invoices ,request: result[:request], user: result[:user], request_date: result[:request_date] }, status: :ok
      end 
    end
    
    def request_draft
      request = ExpenseReport::Request.find(params[:id])
      if request.request_state.name == 'draft'
        render json: request, serializer: ExpenseReport::RequestSerializer, is_show: true, status: :ok
      else
        render json: { message: "false"}, status: :ok
      end
    end

    def response_request
      response = params[:request][0]
      request = ExpenseReport::Request.find(params[:request][1].to_i)
      if response == 'true' && request.request_state.name == 'envoy'
        request.update(request_state_id: ExpenseReport::RequestState.find_by(name: 'approved').id)
        UserNotifierMailer.notification_new_request(request).deliver
        UserNotifierMailer.notification_request_approved_to_user(request).deliver
        UserNotifierMailer.notification_request_approved_to_boss(request).deliver
        render json: { message: "true" }, status: :ok
      elsif response == 'false' && request.request_state.name == 'envoy'
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
    
    def update
      @request.set_state(params[:request][:request_state])
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

    private 

    def set_data_request(requests)
      data = []
      requests.each do |request|
        data << {
          id: request.id,
          created_at: request.created_at.strftime('%d/%m/%Y %H:%M hrs'),
          status: request.request_state.code
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
  