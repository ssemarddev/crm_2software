class SubproyectosController < ApplicationController
  before_action :set_subproyecto, only: [:show, :edit, :update, :destroy]

  # GET /subproyectos
  # GET /subproyectos.json
  def index
    @subproyectos = Subproyecto.all
  end

  # GET /subproyectos/1
  # GET /subproyectos/1.json
  def show
  end

  # GET /subproyectos/new
  def new
    @subproyecto = Subproyecto.new
  end

  # GET /subproyectos/1/edit
  def edit
  end

  # POST /subproyectos
  # POST /subproyectos.json
  def create
    @subproyecto = Subproyecto.new(subproyecto_params)
    @proyecto = Proyecto.find_by(id: @subproyecto.proyecto)
    respond_to do |format|
      if @subproyecto.save
        params[:subproyecto][:creado_por]      = session[:user_id]
        params[:subproyecto][:actualizado_por] = session[:user_id]
        format.html { redirect_to @proyecto, notice: 'Subproyecto was successfully created.' }
        format.json { render :show, status: :created, location: @subproyecto }
      else
        format.html { render :new }
        format.json { render json: @subproyecto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subproyectos/1
  # PATCH/PUT /subproyectos/1.json
  def update
    respond_to do |format|
      params[:subproyecto][:actualizado_por] = session[:user_id]
      if @subproyecto.update(subproyecto_params)
        format.html { redirect_to @subproyecto, notice: 'Subproyecto was successfully updated.' }
        format.json { render :show, status: :ok, location: @subproyecto }
      else
        format.html { render :edit }
        format.json { render json: @subproyecto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subproyectos/1
  # DELETE /subproyectos/1.json
  def destroy
    @subproyecto.destroy
    respond_to do |format|
      format.html { redirect_to subproyectos_url, notice: 'Subproyecto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subproyecto
      @subproyecto = Subproyecto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subproyecto_params
      params.require(:subproyecto).permit(:nombre, :proyecto_id, :estado, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
