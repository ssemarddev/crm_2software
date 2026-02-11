class DetalleMedidasController < ApplicationController
  before_action :set_detalle_medida, only: [:show, :edit, :update, :destroy]

  # GET /detalle_medidas
  # GET /detalle_medidas.json
  def index
    if params[:deleted]
      @detalle_medidas = DetalleMedida.where(estado: false)
    else
      @detalle_medidas = DetalleMedida.where(estado: true)
    end
  end

  # GET /detalle_medidas/1
  # GET /detalle_medidas/1.json
  def show
  end

  # GET /detalle_medidas/new
  def new
    @detalle_medida = DetalleMedida.new
  end

  # GET /detalle_medidas/1/edit
  def edit
  end

  # POST /detalle_medidas
  # POST /detalle_medidas.json
  def create
    params[:detalle_medida][:creado_por]      = session[:user_id]
    params[:detalle_medida][:actualizado_por] = session[:user_id]
    params[:detalle_medida][:estado] = true
    @detalle_medida = DetalleMedida.new(detalle_medida_params)

    respond_to do |format|
      if @detalle_medida.save
        format.html { redirect_to detalle_medidas_path, notice: 'Detalle medida was successfully created.' }
        format.json { render :show, status: :created, location: @detalle_medida }
      else
        format.html { render :new }
        format.json { render json: @detalle_medida.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /detalle_medidas/1
  # PATCH/PUT /detalle_medidas/1.json
  def update
    respond_to do |format|
    params[:detalle_medida][:actualizado_por] = session[:user_id]
    params[:detalle_medida][:estado] = true
      if @detalle_medida.update(detalle_medida_params)
        format.html { redirect_to detalle_medidas_path, notice: 'Detalle medida was successfully updated.' }
        format.json { render :show, status: :ok, location: @detalle_medida }
      else
        format.html { render :edit }
        format.json { render json: @detalle_medida.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /detalle_medidas/1
  # DELETE /detalle_medidas/1.json
  def destroy
    @detalle_medida.estado = false
    @detalle_medida.save
    respond_to do |format|
      format.html { redirect_to detalle_medidas_url, notice: 'Detalle medida was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_detalle_medida
      @detalle_medida = DetalleMedida.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def detalle_medida_params
      params.require(:detalle_medida).permit(:estado, :Nombre, :Medida_id, :Proporcion, :Porcentaje_Ganancia)
    end
end
