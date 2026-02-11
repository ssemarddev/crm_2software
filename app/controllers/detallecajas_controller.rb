class DetallecajasController < ApplicationController
  before_action :set_detallecaja, only: [:show, :edit, :update, :destroy]

  # GET /detallecajas
  # GET /detallecajas.json
  def index
    @detallecajas = Detallecaja.all
  end

  # GET /detallecajas/1
  # GET /detallecajas/1.json
  def show
  end

  # GET /detallecajas/new
  def new
    @detallecaja = Detallecaja.new
  end

  # GET /detallecajas/1/edit
  def edit
  end

  # POST /detallecajas
  # POST /detallecajas.json
  def create
    params[:detallecaja][:status] = true
    params[:detallecaja][:creado_por] = session[:user_id]
    params[:detallecaja][:actualizado_por] = session[:user_id]
    @detallecaja = Detallecaja.new(detallecaja_params)

    respond_to do |format|
      if @detallecaja.save
        format.html { redirect_to edit_caja_path(@detallecaja.caja), notice: 'Detallecaja was successfully created.' }
        format.json { render :show, status: :created, location: @detallecaja }
      else
        format.html { render :new }
        format.json { render json: @detallecaja.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /detallecajas/1
  # PATCH/PUT /detallecajas/1.json
  def update
    respond_to do |format|
      params[:detallecaja][:actualizado_por] = session[:user_id]
      if @detallecaja.update(detallecaja_params)
        format.html { redirect_to @detallecaja, notice: 'Detallecaja was successfully updated.' }
        format.json { render :show, status: :ok, location: @detallecaja }
      else
        format.html { render :edit }
        format.json { render json: @detallecaja.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /detallecajas/1
  # DELETE /detallecajas/1.json
  def destroy
    @detallecaja.destroy
    respond_to do |format|
      format.html { redirect_to detallecajas_url, notice: 'Detallecaja was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_detallecaja
      @detallecaja = Detallecaja.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def detallecaja_params
      params.require(:detallecaja).permit(:caja_id, :cantidad, :tipo, :razon, :status, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
