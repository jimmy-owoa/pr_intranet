module Admin
  class BenefitsController < ApplicationController
    layout 'admin'
    before_action :set_benefit, only: [:show, :edit, :update, :destroy]

    def index
      @benefits = General::Benefit.order(id: :desc).all
    end

    def show
    end

    def new
      @benefit = General::Benefit.new
      @benefit.terms.build
    end

    def edit
    end

    def create
      @benefit = General::Benefit.new(benefit_params)
      respond_to do |format|
        if @benefit.save
          set_tags
          format.html { redirect_to admin_benefit_path(@benefit), notice: 'Benefit was successfully created.'}
          format.json { render :show, status: :created, location: @benefit}
        else
          format.html {render :new}
          format.json {render json: @benefit.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      respond_to do |format|
        if @benefit.update(benefit_params)
          set_tags
          format.html { redirect_to admin_benefit_path(@benefit), notice: 'Benefit was successfully updated.'}
          format.json { render :show, status: :ok, location: @benefit }
        else
          format.html { render :edit}
          format.json { render json: @benefit.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @benefit.destroy
      respond_to do |format|
        format.html { redirect_to admin_benefits_path, notice: 'Benefit was successfully destroyed.'}
        format.json { head :no_content }
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_benefit
      @benefit = General::Benefit.find(params[:id])
    end

    def set_tags
      # Getting terms_names from the form (tags)
      term_names = params[:terms_names]
      terms = []
      if term_names.present?
        term_names.uniq.each do |tag|
          terms << General::Term.where(name: tag, term_type: General::TermType.tag).first_or_create
        end
        @benefit.terms << terms
      end   
    end    

    def benefit_params
      params.require(:benefit).permit(:title, :content, :image, terms_names: [])
    end
  end
end
