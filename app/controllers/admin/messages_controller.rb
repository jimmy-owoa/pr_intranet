module Admin
  class MessagesController < ApplicationController
    layout 'admin'
    before_action :set_message, only: [:show, :edit, :update, :destroy]

    def index
      @messages = General::Message.order(id: :desc).all
    end

    def show
      add_breadcrumb "Messages", :admin_messages_path
    end
    
    def new
      add_breadcrumb "Messages", :admin_messages_path
      @message = General::Message.new
      @message_types = General::Message::MESSAGE_TYPES
    end

    def edit
      add_breadcrumb "Messages", :admin_messages_path
    end

    def create
      @message = General::Message.new(message_params)
      respond_to do |format|
        if @message.save
          set_tags
          format.html { redirect_to admin_message_path(@message), notice: 'Message was successfully created.'}
          format.json { render :show, status: :created, location: @message}
          format.js
        else
          format.html {render :new}
          format.json {render json: @message.errors, status: :unprocessable_entity}
          format.js
        end
      end
    end

    def update
      respond_to do |format|
        if @message.update(message_params)
          set_tags
          format.html { redirect_to admin_message_path(@message), notice: 'Message was successfully updated.'}
          format.json { render :show, status: :ok, location: @message }
        else
          format.html { render :edit}
          format.json { render json: @message.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @message.destroy
      respond_to do |format|
        format.html { redirect_to admin_messages_path, notice: 'Message was successfully destroyed.'}
        format.json { head :no_content }
      end
    end

    private

    def set_message
      @message = General::Message.find(params[:id])
    end

    def set_tags
      # Getting terms_names from the form (tags)
      term_names = params[:terms_names]
      terms = []
      if term_names.present?
        term_names.uniq.each do |tag|
          terms << General::Term.where(name: tag, term_type: General::TermType.tag).first_or_create
        end
        @message.terms << terms
      end   
    end    

    def message_params
      params.require(:message).permit(:title, :content, :message_type, :is_const, :image, terms_names: [])
    end
  end
end