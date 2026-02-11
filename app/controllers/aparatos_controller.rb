class AparatosController < ApplicationController
  before_action :set_aparato, only: [:show, :edit, :update, :destroy]

  # GET /aparatos
  # GET /aparatos.json
  def index
    if params[:deleted]
      @aparatos = Aparato.where(status:false)
    else
      @aparatos = Aparato.where(status: true)
    end
  end

  # GET /aparatos/1
  # GET /aparatos/1.json
  def show
  end

  # GET /aparatos/new
  def new
    @aparato = Aparato.new
  end

  # GET /aparatos/1/edit
  def edit
  end

  # POST /aparatos
  # POST /aparatos.json
  def create
    params[:aparato][:creado_por]      = session[:user_id]
    params[:aparato][:actualizado_por] = session[:user_id]
    params[:aparato][:status]          = true

    @aparato = Aparato.new(aparato_params)
    respond_to do |format|
      if @aparato.save
        remplazo = params[:aparato][:serie_remplazo]
        serieRemplazo = Aparato.find_by(serie: remplazo)
        if serieRemplazo != nil
          serieRemplazo.bodega_id = @aparato.bodega_id
          serieRemplazo.cliente = @aparato.cliente
          serieRemplazo.estado = Estado.find_by(Nombre: "INSTALADO")
          serieRemplazo.save
          @aparato.estado = Estado.find_by(Nombre: "BAJA")
          @aparato.cov = serieRemplazo.cov
          @aparato.save
        end
        format.html { redirect_to aparatos_url, notice: 'Aparato was successfully created.' }
        format.json { render :show, status: :created, location: @aparato }
      else
        format.html { render :new }
        format.json { render json: @aparato.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aparatos/1
  # PATCH/PUT /aparatos/1.json
  def update
    respond_to do |format|
      params[:aparato][:actualizado_por] = session[:user_id]
      if @aparato.update(aparato_params)
        remplazo = params[:aparato][:serie_remplazo]
        serieRemplazo = Aparato.find_by(serie: remplazo)
        if serieRemplazo != nil
          serieRemplazo.bodega_id = @aparato.bodega_id
          serieRemplazo.cliente = @aparato.cliente
          serieRemplazo.estado = Estado.find_by(Nombre: "INSTALADO")
          serieRemplazo.save
          @aparato.estado = Estado.find_by(Nombre: "BAJA")
          @aparato.cov_remplazo = serieRemplazo.cov
          @aparato.save
        end
        format.html { redirect_to aparatos_url, notice: 'Aparato was successfully updated.' }
        format.json { render :show, status: :ok, location: @aparato }
      else
        format.html { render :edit }
        format.json { render json: @aparato.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /aparatos/1
  # DELETE /aparatos/1.json
  def destroy
    @aparato.status = false
    @aparato.save
    respond_to do |format|
      format.html { redirect_to aparatos_url, notice: 'Aparato was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aparato
      @aparato = Aparato.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def aparato_params
      params.require(:aparato).permit(:serie, :cov, :bodega_id, :serie_remplazo, :cov_remplazo, :proveedor, :cliente, :estado_id, :comentario, :status, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
