class TrackingsController < ApplicationController
  before_action :set_tracking, only: [:show, :edit, :update, :destroy]

  # GET /trackings
  # GET /trackings.json
  def index
    if params[:deleted]
      @trackings = Tracking.where(state: false)
    else
      @trackings = Tracking.where(state: true)
    end
  end

  # GET /trackings/1
  # GET /trackings/1.json
  def show
    require 'rqrcode'
    @estados = Estadortacking.where(:tracking => @tracking.id)
    @qr = RQRCode::QRCode.new(Empresa.all.first.domain.to_s+"/trk?b="+@tracking.numero.to_s, :size => 5, :level => :h )

  end

  # GET /trackings/new
  def new
    @tracking = Tracking.new
  end

  # GET /trackings/1/edit
  def edit
  end

  # POST /trackings
  # POST /trackings.json
  def create
    params[:tracking][:numero] = Tracking.maximum("numero") == nil ? 0001 :  Tracking.all.order("CAST ( numero AS integer ) desc").first.numero.to_i + 1
    params[:tracking][:creado_por]      = session[:user_id]
    params[:tracking][:actualizado_por] = session[:user_id]
    @tracking = Tracking.new(tracking_params)
    respond_to do |format|
      if @tracking.save
        @estado = Estadortacking.new
        @estado.tracking = @tracking
        @estado.estado   = @tracking.estado
        @estado.comentario = params[:tracking][:descripcion]
        @estado.creado_por = session[:user_id]
        @estado.actualizado_por = session[:user_id]
        @estado.status = true
        @estado.save
        format.html { redirect_to @tracking, notice: 'Tracking was successfully created.' }
        format.json { render :show, status: :created, location: @tracking }
      else
        format.html { render :new }
        format.json { render json: @tracking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trackings/1
  # PATCH/PUT /trackings/1.json
  def update
    respond_to do |format|
      params[:tracking][:actualizado_por] = session[:user_id]
      if @tracking.update(tracking_params)
        format.html { redirect_to @tracking, notice: 'Tracking was successfully updated.' }
        format.json { render :show, status: :ok, location: @tracking }
      else
        format.html { render :edit }
        format.json { render json: @tracking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trackings/1
  # DELETE /trackings/1.json
  def destroy
    @tracking.state = false
    @tracking.save
    respond_to do |format|
      format.html { redirect_to trackings_url, notice: 'Tracking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tracking
      @tracking = Tracking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tracking_params
      params.require(:tracking).permit(:precio, :nombre_cliente, :numero_contacto, :clave, :numero, :descripcion, :direccionOrigen, :direccionDestion, :cliente_proveedor_id, :estado_id, :state, :creado_por, :actualizado_por, :creado, :actualizado ,:serie ,:marca ,:observacion ,:falla, :nombre_cliente)
    end
end
