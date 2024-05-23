module Api::V1
  class HcTicketsController < ApiController
    # skip_before_action :verify_authenticity_token
    # skip_before_action :authenticate_user!, only: [:index, :show, :ofertas, :create_postulacion]
    before_action :set_ticket, only: [:show, :update_postulacion_status]

    def index
      tickets = Helpcenter::Ticket.all.order(created_at: :desc)
      render json: tickets, each_serializer: Helpcenter::TicketSerializer, status: :ok
    end

    def show
      render json: @ticket, serializer: Helpcenter::TicketSerializer, is_show: true, status: :ok
    end

    def index_job_applications
      job_applications = Helpcenter::JobApplication.all.order(created_at: :desc)
      
      data = job_applications.map do |job_application|
        {
          id: job_application.id,
          applicant_name: job_application.applicant_name&.gsub('_', ' '),
          email: job_application.email,
          phone: job_application.phone,
          application_status: job_application.application_status&.gsub('_', ' '),
          requested_position_title: job_application.ticket&.requested_position_title&.gsub('_', ' ').capitalize,
          created_at: job_application.created_at.strftime('%d/%m/%Y %H:%M hrs'),
        }
      end
    
      render json: data, status: :ok
    end

    def update_postulacion_status
      @postulacion = @ticket.postulaciones.find(params[:postulacion_id])
      if @postulacion.update(application_status_params)
        redirect_to admin_helpcenter_ticket_path(@ticket), notice: 'El estado de la postulación ha sido actualizado.'
      else
        redirect_to admin_helpcenter_ticket_path(@ticket), alert: 'No se pudo actualizar el estado de la postulación.'
      end
    end
    

    def ofertas
      oferta = Helpcenter::Ticket.find(params[:id])
      render json: oferta, serializer: Helpcenter::TicketSerializer, is_show: true, status: :ok
    end

    def create
      ticket = Helpcenter::Ticket.new(ticket_params)
      ticket.user_id = @request_user.id
      if ticket.save
        Helpcenter::TicketHistory.create(user_id: @request_user.id, ticket_id: ticket.id, ticket_state_id: Helpcenter::TicketState.find_by(status: 'open').id)
        UserNotifierMailer.notification_new_ticket(ticket, @request_user).deliver
        render json: { message: "Ticket created", success: true }, status: :created
      else
        render json: { message: "Error", success: false }, status: :unprocessable_entity
      end
    end

    def create_postulacion
      # Encuentra el ticket/oferta usando el ID
      ticket = Helpcenter::Ticket.find(params[:id])
  
      # Aquí, crea una nueva postulación asociada a este ticket
      postulacion = ticket.postulaciones.new(postulacion_params)
      postulacion.application_status = "recibida"
      if postulacion.save
        render json: postulacion, status: :created
      else
        render json: { errors: postulacion.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def assign_assistant 
      @ticket = Helpcenter::Ticket.find(params[:id])
      @ticket.update(assistant_id: params[:helpcenter_ticket][:assistant_id])
      
      if @ticket.save
        flash[:success] = "Asistente asignado correctamente"
      else
        flash[:error] = "Hubo un error al asignar el asistente"
      end
      redirect_to admin_helpcenter_ticket_path(@ticket) 
    end

    def review_ticket
      approved_to_review = params[:aproved_to_review].tr('=', '')
      # comprobar si el ticket esta expirado y enviar correos
      result = Helpcenter::Ticket.ticket_boss_notifications(approved_to_review)
      if  result[:state] == "link_expired"
        Helpcenter::TicketHistory.create(user_id: result[:user].id, ticket_id: result[:ticket].id, ticket_state_id: Helpcenter::TicketState.find_by(status: 'expired').id, supervisor_id: result[:user].id_exa_boss )
        render json: { message: "Link expired", success: true, ticket: result[:ticket], user: result[:user],ticket_date: result[:ticket_date]}, status: :ok
      elsif  result[:state] == "rejected"
        Helpcenter::TicketHistory.create(user_id: result[:user].id, ticket_id: result[:ticket].id, ticket_state_id: Helpcenter::TicketState.find_by(status: 'rejected').id, supervisor_id: result[:user].id_exa_boss)
        render json: { message: "Ticket rejected", success: true, ticket: result[:ticket], user: result[:user],ticket_date: result[:ticket_date] }, status: :ok
      else
        Helpcenter::TicketHistory.create(user_id: result[:user].id, ticket_id: result[:ticket].id, ticket_state_id: Helpcenter::TicketState.find_by(status: 'approved').id, supervisor_id: result[:user].id_exa_boss )
        render json: { message: "Ticket approved", success: true, ticket: result[:ticket], user: result[:user], ticket_date: result[:ticket_date] }, status: :ok
      end 
    end
    
    def divisas 
      data = Helpcenter::Ticket::DIVISAS
      render json: data, is_show: true, status: :ok
    end

    private

    def set_ticket
      @ticket = Helpcenter::Ticket.find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:subcategory_id, :description, :amount, :currency_type, :user_id, files: [])
    end
    
    def category_params
      params.require(:category).permit(:category_id)
    end

    def postulacion_params
      params.permit(:applicant_name, :email, :phone, :file) # Asegúrate de incluir todos los campos necesarios
    end

    def application_status_params
      params.require(:helpcenter_job_application).permit(:application_status)
    end
  end
end