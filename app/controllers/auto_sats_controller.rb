class AutoSatsController < ApplicationController
  before_action :set_auto_sat, only: [:show, :edit, :update, :destroy]

  # GET /auto_sats
  # GET /auto_sats.json
  def index
    @auto_sats = AutoSat.all
  end

  # GET /auto_sats/1
  # GET /auto_sats/1.json
  def show
  end

  # GET /auto_sats/new
  def new
    @auto_sat = AutoSat.new
  end

  # GET /auto_sats/1/edit
  def edit
  end

  # POST /auto_sats
  # POST /auto_sats.json
  def create
    params[:auto_sat][:creado_por]      = session[:user_id]
    params[:auto_sat][:actualizado_por] = session[:user_id]
    @auto_sat = AutoSat.new(auto_sat_params)
    respond_to do |format|
      if @auto_sat.save
        format.html { redirect_to @auto_sat, notice: 'Auto sat was successfully created.' }
        format.json { render :show, status: :created, location: @auto_sat }
      else
        format.html { render :new }
        format.json { render json: @auto_sat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auto_sats/1
  # PATCH/PUT /auto_sats/1.json
  def update
    respond_to do |format|
      params[:auto_sat][:actualizado_por] = session[:user_id]
      if @auto_sat.update(auto_sat_params)
        format.html { redirect_to @auto_sat, notice: 'Auto sat was successfully updated.' }
        format.json { render :show, status: :ok, location: @auto_sat }
      else
        format.html { render :edit }
        format.json { render json: @auto_sat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auto_sats/1
  # DELETE /auto_sats/1.json
  def destroy
    @auto_sat.destroy
    respond_to do |format|
      format.html { redirect_to auto_sats_url, notice: 'Auto sat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auto_sat
      @auto_sat = AutoSat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auto_sat_params
      params.require(:auto_sat).permit(:Numero_autorizacion, :Serie, :Actual, :Inicio, :Fin, :Bodega_id, :Estado, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
