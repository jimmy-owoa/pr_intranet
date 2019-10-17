module Admin
  class MessagesController < AdminController
    before_action :set_message, only: [:show, :edit, :update, :destroy]

    def index
      @messages = General::Message.order(id: :desc).all
    end

    def show
    end

    def new
      @message = General::Message.new
      @message_types = General::Message::MESSAGE_TYPES
    end

    def edit
      @message_types = General::Message::MESSAGE_TYPES
    end

    def create
      @message = General::Message.new(message_params)
      respond_to do |format|
        if @message.save
          @message.set_users
          format.html { redirect_to admin_message_path(@message), notice: "Mensaje fue creado con éxito." }
          format.json { render :show, status: :created, location: @message }
          format.js
        else
          format.html { render :new }
          format.json { render json: @message.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def update
      respond_to do |format|
        if @message.update(message_params)
          @message.set_users
          format.html { redirect_to admin_message_path(@message), notice: "Mensaje fue actualizado con éxito." }
          format.json { render :show, status: :ok, location: @message }
        else
          format.html { render :edit }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @message.destroy
      respond_to do |format|
        format.html { redirect_to admin_messages_path, notice: "Mensaje fue eliminado con éxito." }
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
      params.require(:message).permit(:title, :content, :message_type, :is_const, :image, :profile_id)
    end
  end
end
