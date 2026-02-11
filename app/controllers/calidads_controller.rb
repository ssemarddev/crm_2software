class CalidadsController < ApplicationController
  before_action :set_calidad, only: [:show, :edit, :update, :destroy]

  # GET /calidads
  # GET /calidads.json
  def index
    if params[:deleted]
      @calidads = Calidad.where(status:false)
    else
      @calidads = Calidad.where(status: true)
    end
  end

  # GET /calidads/1
  # GET /calidads/1.json
  def show
  end

  # GET /calidads/new
  def new
    @calidad = Calidad.new
  end

  # GET /calidads/1/edit
  def edit
  end

  # POST /calidads
  # POST /calidads.json
  def create
    params[:calidad][:creado_por]      = session[:user_id]
    params[:calidad][:actualizado_por] = session[:user_id]
    @calidad = Calidad.new(calidad_params)

    respond_to do |format|
      if @calidad.save
        format.html { redirect_to calidads_url, notice: 'Calidad was successfully created.' }
        format.json { render :show, status: :created, location: @calidad }
      else
        format.html { render :new }
        format.json { render json: @calidad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calidads/1
  # PATCH/PUT /calidads/1.json
  def update
    respond_to do |format|
      params[:calidad][:actualizado_por] = session[:user_id]
      if @calidad.update(calidad_params)
        format.html { redirect_to calidads_url, notice: 'Calidad was successfully updated.' }
        format.json { render :show, status: :ok, location: @calidad }
      else
        format.html { render :edit }
        format.json { render json: @calidad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calidads/1
  # DELETE /calidads/1.json
  def destroy
    @calidad.status = false
    if @calidad.save
      respond_to do |format|
        format.html { redirect_to calidads_url, notice: 'Registro eliminado exitosamente.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to calidads_url, notice: 'No se pudo eliminar este registro'+@calidad.errors.messages[:base][0].to_s  }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calidad
      @calidad = Calidad.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calidad_params
      params.require(:calidad).permit(:nombre, :status, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
