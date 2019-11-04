module Admin
  class FilesController < AdminController
    before_action :set_file, only: [:show, :edit, :update, :destroy]

    def index
      @files = General::File.order(created_at: :desc)
    end

    def show
    end

    def new
      @file = General::File.new
    end

    def edit
    end

    def create
      @file = General::File.new(file_params)
      respond_to do |format|
        if @file.save
          format.html { redirect_to admin_file_path(@file), notice: "Archivo fue creado con éxito." }
          format.json { render :show, status: :created, location: @file }
          format.js
        else
          format.html { render :new }
          format.json { render json: @file.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def update
      respond_to do |format|
        if @file.update(file_params)
          format.html { redirect_to admin_file_path(@file), notice: "Archivo fue actualizado con éxito." }
          format.json { render :show, status: :ok, location: @file }
        else
          format.html { render :edit }
          format.json { render json: @file.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @file.destroy
      respond_to do |format|
        format.html { redirect_to admin_files_path, notice: "Archivo fue eliminado con éxito." }
        format.json { head :no_content }
      end
    end

    private

    def set_file
      @file = General::File.find(params[:id])
    end

    def file_params
      params.require(:file).permit(:name, :file)
    end
  end
end
