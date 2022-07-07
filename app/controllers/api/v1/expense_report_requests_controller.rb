module Api::V1
    class ExpenseReportRequestsController < ApiController
      before_action :set_request, only: [:show]
      skip_before_action :set_current_user_from_header, only: [:review_request, :response_request]
      skip_before_action :verify_authenticity_token

      def index
        status = params[:status].downcase
        if status == 'todos'
          requests = @request_user.requests.order(created_at: :desc)
        else
          id_status = ExpenseReport::RequestState.find_by(code: status).id
          requests = @request_user.requests.where(request_state_id: id_status ).order(created_at: :desc)
        end
        render json: requests, each_serializer: ExpenseReport::RequestSerializer, status: :ok
      end

      def show
        render json: @request, serializer: ExpenseReport::RequestSerializer, is_show: true, status: :ok
      end

      def create
        request = ExpenseReport::Request.new(request_params)
        if request.save
          # enviar correo al supervisor
          UserNotifierMailer.notification_new_request_boss(request).deliver
          request.update(request_state_id: ExpenseReport::RequestState.find_by(name: 'awaiting approval').id, country: request.user.country) #se asigna el estado en espera de aprobación
          # recorrer los requests para crear los invoice
          total_request = 0
          params[:invoice].permit!.to_h.each do |r|
            invoice = ExpenseReport::Invoice.create(r[1])
            invoice.update(request_id: request.id)
            total_request += r[1][:total].to_i
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
        result[:request].invoices.each do |i|
        invoices << {
            invoice: i,
            subcategory: i.subcategory.name,
            file: root_url + rails_blob_path(i.file, disposition: "attachment")     
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



      private

      def set_request
        @request = ExpenseReport::Request.find(params[:id])
      end

      def request_params
        params.require(:request).permit(:subcategory_id, :description, :user_id, :society_id, :divisa_id, [])
      end
    end
  end
    