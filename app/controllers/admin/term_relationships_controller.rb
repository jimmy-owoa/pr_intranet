module Admin
  class TermRelationshipsController < AdminController
    before_action :set_term_relationship, only: [:show, :edit, :update, :destroy]

    def index
      @term_relationships = General::TermRelationship.all
    end

    def show
    end

    def new
      @term_relationship = General::TermRelationship.new
    end

    def edit
    end

    def create
      @term_relationship = General::TermRelationship.new(term_relationship_params)
      respond_to do |format|
        if @term_relationship.save
          format.html { redirect_to edit_admin_term_relationship_path(@term_relationship), notice: 'TermRelationship was successfully created.'}
          format.json { render :show, status: :created, location: @term_relationship}
        else
          format.html {render :new}
          format.json {render json: @term_relationship.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      respond_to do |format|
        if @term_relationship.update(term_relationship_params)
          format.html { redirect_to [:admin, @term_relationship], notice: 'TermRelationship was successfully updated.'}
          format.json { render :show, status: :ok, location: @term_relationship }
        else
          format.html { render :edit}
          format.json { render json: @term_relationship.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @term_relationship.destroy
      respond_to do |format|
        format.html { redirect_to admin_term_relationships_path, notice: 'TermRelationship was successfully destroyed.'}
        format.json { head :no_content }
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_term_relationship
      @term_relationship = General::TermRelationship.find(params[:id])
    end

    def term_relationship_params
      params.require(:term_relationship).permit(:object_type, :object_id, :term_order, :term_id)
    end
  end
end
