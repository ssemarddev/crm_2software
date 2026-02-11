class TarjetaCreditosController < ApplicationController
  before_action :set_tarjeta_credito, only: [:show, :edit, :update, :destroy]

  # GET /tarjeta_creditos
  # GET /tarjeta_creditos.json
  def index
    @tarjeta_creditos = TarjetaCredito.all
  end

  # GET /tarjeta_creditos/1
  # GET /tarjeta_creditos/1.json
  def show
  end

  # GET /tarjeta_creditos/new
  def new
    @tarjeta_credito = TarjetaCredito.new
  end

  # GET /tarjeta_creditos/1/edit
  def edit
  end

  # POST /tarjeta_creditos
  # POST /tarjeta_creditos.json
  def create
    @tarjeta_credito = TarjetaCredito.new(tarjeta_credito_params)

    respond_to do |format|
      if @tarjeta_credito.save
        format.html { redirect_to @tarjeta_credito, notice: 'Tarjeta credito was successfully created.' }
        format.json { render :show, status: :created, location: @tarjeta_credito }
      else
        format.html { render :new }
        format.json { render json: @tarjeta_credito.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tarjeta_creditos/1
  # PATCH/PUT /tarjeta_creditos/1.json
  def update
    respond_to do |format|
      if @tarjeta_credito.update(tarjeta_credito_params)
        format.html { redirect_to @tarjeta_credito, notice: 'Tarjeta credito was successfully updated.' }
        format.json { render :show, status: :ok, location: @tarjeta_credito }
      else
        format.html { render :edit }
        format.json { render json: @tarjeta_credito.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tarjeta_creditos/1
  # DELETE /tarjeta_creditos/1.json
  def destroy
    @tarjeta_credito.destroy
    respond_to do |format|
      format.html { redirect_to tarjeta_creditos_url, notice: 'Tarjeta credito was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tarjeta_credito
      @tarjeta_credito = TarjetaCredito.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tarjeta_credito_params
      params.require(:tarjeta_credito).permit(:nombre, :estado, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
