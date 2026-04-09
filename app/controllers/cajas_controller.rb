class CajasController < ApplicationController
  before_action :set_caja, only: [:show, :edit, :update, :destroy]

  # GET /cajas
  # GET /cajas.json
  def index
    if user_is_admin
      @cajas = Caja.all.order(created_at: :desc)
    else
      @cajas = Caja.where(usuario_id: session[:user_id]).order(created_at: :desc)
    end
  end

  # GET /cajas/1
  # GET /cajas/1.json
  def show
  end

  # GET /cajas/new
def new
  caja_abierta = Caja.where(usuario_id: session[:user_id], Estado: [false, nil]).order(created_at: :desc).first

  if caja_abierta.present? && !user_is_admin
    redirect_to edit_caja_path(caja_abierta), alert: 'Ya tienes una caja abierta.'
    return
  end

  @caja = Caja.new
  @caja.usuario_id = session[:user_id] unless user_is_admin
  @open = true
end

  # GET /cajas/1/edit
  def edit
    @open = false
    @detalleCaja = Detallecaja.where(caja_id: @caja.id)
  end

  # POST /cajas
def create
    params[:caja][:creado_por] = session[:user_id]
    params[:caja][:Estado] = false

    unless user_is_admin
      params[:caja][:usuario_id] = session[:user_id]
    end

    @caja = Caja.new(caja_params)

    respond_to do |format|
      if @caja.save
        format.html { redirect_to edit_caja_path(@caja), notice: 'Caja aperturada correctamente.' }
        format.json { render :show, status: :created, location: @caja }
      else
        @open = true
        format.html { render :new }
        format.json { render json: @caja.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cajas/1
  # PATCH/PUT /cajas/1.json
  def update
    respond_to do |format|
      params[:caja][:Estado] = true
      params[:caja][:actualizado_por] = session[:user_id]

      # Si es caja normal (no caja chica), calcular automáticamente los totales reales
      if @caja.tipo != 2
        pagos = DocumentoPago.where(
          caja_id: @caja.id,
          Tipo_Documento: 2,
          Estado: true
        )

        efectivo = pagos.sum(:Pago_Efectivo).to_f
        tarjeta  = pagos.sum(:Pago_Tarjeta).to_f
        cambio   = pagos.sum(:cambio).to_f
        deposito = pagos.sum(:pago_deposito).to_f

        total_efectivo = efectivo - cambio
        total_pos      = tarjeta + deposito

        params[:caja][:FinalEfectivo] = total_efectivo
        params[:caja][:FinalPos]      = total_pos
      end

      if @caja.update(caja_params)
        format.html { redirect_to cajas_url, notice: 'Caja was successfully updated.' }
        format.json { render :show, status: :ok, location: @caja }
      else
        format.html { render :edit }
        format.json { render json: @caja.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cajas/1
  # DELETE /cajas/1.json
  def destroy
    @caja.destroy
    respond_to do |format|
      format.html { redirect_to cajas_url, notice: 'Caja was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_caja
      @caja = Caja.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def caja_params
      params.require(:caja).permit(:Nombre, :usuario_id, :InicialEfectivo, :FinalEfectivo, :FinalPos, :Estado, :creado_por, :actualizado_por, :creado, :actualizado, :tipo)
    end
end
