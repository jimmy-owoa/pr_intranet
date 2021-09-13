module Api::V1
  class HcSatisfactionAnswersController < ApiController
    skip_before_action :verify_authenticity_token
    before_action :set_ticket

    def create
      answer = Helpcenter::SatisfactionAnswer.new(answer_params)
      answer.user_id = @request_user.id
      answer.ticket_id = @ticket.id

      if answer.save
        render json: { message: "answer created success", success: true}, status: :created
      else
        render json: { message: "Error", success: false }, status: :unprocessable_entity
      end

    end

    private

    def answer_params
      params.require(:answer).permit(:value)
    end

    def set_ticket
      @ticket = Helpcenter::Ticket.find(params[:hc_ticket_id])
      return record_not_found if @ticket.nil?
    end
  end
end
