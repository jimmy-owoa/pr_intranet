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

      if ticket.save
        # UserNotifierMailer.notification_new_ticket(ticket, @request_user).deliver
        render json: { message: "Ticket created", success: true }, status: :created
      else
        render json: { message: "Error", success: false }, status: :unprocessable_entity
      end
    end

    private

    def set_ticket
      @ticket = Helpcenter::Ticket.find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:category_id, :description, files: [])
    end
  end
end