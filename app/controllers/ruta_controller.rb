class RutaController < ApplicationController
  before_action :set_rutum, only: [:show, :edit, :update, :destroy]

  # GET /ruta
  # GET /ruta.json
  def index
    if params[:deleted]
      @ruta = Rutum.where(status: false)
    else
      @ruta = Rutum.where(status: true)
    end
  end

  # GET /ruta/1
  # GET /ruta/1.json
  def show
  end

  # GET /ruta/new
  def new
    @rutum = Rutum.new
  end

  # GET /ruta/1/edit
  def edit
  end

  # POST /ruta
  # POST /ruta.json
  def create
    params[:rutum][:creado_por]      = session[:user_id]
    params[:rutum][:actualizado_por] = session[:user_id]
    @rutum = Rutum.new(rutum_params)

    respond_to do |format|
      if @rutum.save
        format.html { redirect_to ruta_url, notice: 'Ruta was successfully created.' }
        format.json { render :show, status: :created, location: @rutum }
      else
        format.html { render :new }
        format.json { render json: @rutum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ruta/1
  # PATCH/PUT /ruta/1.json
  def update
    respond_to do |format|
      params[:rutum][:actualizado_por] = session[:user_id]
      params[:rutum][:status] = true
      if @rutum.update(rutum_params)
        format.html { redirect_to ruta_url, notice: 'Ruta was successfully updated.' }
        format.json { render :show, status: :ok, location: @rutum }
      else
        format.html { render :edit }
        format.json { render json: @rutum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ruta/1
  # DELETE /ruta/1.json
  def destroy
    @rutum.status = false
    @rutum.save
    respond_to do |format|
      format.html { redirect_to ruta_url, notice: 'Ruta was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rutum
      @rutum = Rutum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rutum_params
      params.require(:rutum).permit(:nombre, :tipo, :piloto, :status, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
