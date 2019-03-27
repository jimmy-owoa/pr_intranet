module Admin
  class TermsController < AdminController
    
    before_action :set_term, only: [:show, :edit, :update, :destroy]

    def index
      if params[:type].present?
        @terms = General::Term.order(id: :desc).where(["permission LIKE ?", "%#{params[:type]}%"]).paginate(:page => params[:page], :per_page => 10)
      else
        @terms = General::Term.order(id: :desc).paginate(:page => params[:page], :per_page => 10)
      end          
    end

    def show
    end

    def new
      @term = General::Term.new
    end

    def edit
    end

    def create
      @term = General::Term.new(term_params)
      respond_to do |format|
        if @term.save
          format.html { redirect_to edit_admin_term_path(@term), notice: 'Term was successfully created.'}
          format.json { render :show, status: :created, location: @term}
        else
          format.html { render :new}
          format.json { render json: @term.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      respond_to do |format|
        if @term.update(term_params)
          format.html { redirect_to admin_term_path(@term), notice: 'Term was successfully updated.'}
          format.json { render :show, status: :ok, location: @term }
        else
          format.html { render :edit}
          format.json { render json: @term.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @term.destroy
      respond_to do |format|
        format.html { redirect_to admin_terms_path, notice: 'Term was successfully destroyed.'}
        format.json { head :no_content }
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_term
      @term = General::Term.find(params[:id])
    end

    def term_params
      params.require(:term).permit(:term_type_id, :description, :parent_id, :name,
         :slug, :term_order, :status, :permission)
    end
  end
end
