module Api::V1
  class HcTicketsController < ApiController
    skip_before_action :verify_authenticity_token
    before_action :set_ticket, only: [:show]

    def index
      tickets = @request_user.tickets
      render json: tickets, each_serializer: Helpcenter::TicketSerializer, status: :ok
    end

    def show
      render json: @ticket, serializer: Helpcenter::TicketSerializer, is_show: true, status: :ok
    end

    def create
      ticket = Helpcenter::Ticket.new(ticket_params)
      ticket.user = @request_user
      if category_params["category_id"].to_i == Helpcenter::Category.find_by(name: 'Rendición de Gastos').id
        ticket.aproved_to_review = nil
        if ticket.save
          UserNotifierMailer.notification_new_ticket_boss(ticket, @request_user).deliver
          render json: { message: "Ticket created", success: true }, status: :created
        else
          render json: { message: "Error", success: false }, status: :unprocessable_entity
        end
      else
        if ticket.save
          UserNotifierMailer.notification_new_ticket(ticket, @request_user).deliver
          render json: { message: "Ticket created", success: true }, status: :created
        else
          render json: { message: "Error", success: false }, status: :unprocessable_entity
        end
      end
    end

    def is_approved
      approved_to_review = params[:aproved_to_review]
      # comprobar si el ticket esta expirado y enviar correos
      result = Helpcenter::Ticket.ticket_boss_notifications(approved_to_review)
      if result == "link_expired"
        render json: { message: "Link expired", success: false }, status: :unprocessable_entity
      elsif result == "rejected"
        render json: { message: "Ticket rejected", success: false }, status: :unprocessable_entity
      else
        render json: { message: "Ticket approved", success: true }, status: :ok
      end 
    end

    private

    def set_ticket
      @ticket = Helpcenter::Ticket.find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:subcategory_id, :description, files: [])
    end
    
    def category_params
      params.require(:category).permit(:category_id)
    end
  end
end