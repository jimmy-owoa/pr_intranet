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
      @request_user = ticket.user
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
      ticket = Helpcenter::Ticket.find(params[:ticket_id])
      @request_user = ticket.user 
      time_expiry = ticket.created_at + 8760.hours # 1 año 
      if DateTime.now >= time_expiry
        redirect_to vista_link_ha_expirado_path
      else
        if params[:aproved_to_review] == "false"
          UserNotifierMailer.notification_ticket_rejected_to_boss(ticket, @request_user).deliver
          UserNotifierMailer.notification_ticket_rejected_to_user(ticket, @request_user).deliver
          ticket.destroy
        else
          ticket.update(aproved_to_review: DateTime.now)
          UserNotifierMailer.notification_new_ticket(ticket, @request_user).deliver
          UserNotifierMailer.notification_ticket_approved_to_boss(ticket, @request_user).deliver
          UserNotifierMailer.notification_ticket_approved_to_user(ticket, @request_user).deliver
        end
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