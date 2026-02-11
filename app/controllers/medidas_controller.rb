class MedidasController < ApplicationController
  before_action :set_medida, only: [:show, :edit, :update, :destroy]

  # GET /medidas
  # GET /medidas.json
  def index
    if params[:deleted]
      @medidas = Medida.where(Estado:false)
    else
      @medidas = Medida.where(Estado: true)
    end
  end

  # GET /medidas/1
  # GET /medidas/1.json
  def show
  end

  # GET /medidas/new
  def new
    @medida = Medida.new
  end

  # GET /medidas/1/edit
  def edit
  end

  # POST /medidas
  # POST /medidas.json
  def create

  params[:medida][:creado_por]      = session[:user_id]
  params[:medida][:actualizado_por] = session[:user_id]
    @medida = Medida.new(medida_params)
    respond_to do |format|
      if @medida.save
        format.html { redirect_to medidas_url, notice: 'Medida was successfully created.' }
        format.json { render :show, status: :created, location: @medida }
      else
        format.html { render :new }
        format.json { render json: @medida.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medidas/1
  # PATCH/PUT /medidas/1.json
  def update
    respond_to do |format|
      params[:medida][:actualizado_por] = session[:user_id]
      if @medida.update(medida_params)
        format.html { redirect_to medidas_url, notice: 'Medida was successfully updated.' }
        format.json { render :show, status: :ok, location: @medida }
      else
        format.html { render :edit }
        format.json { render json: @medida.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medidas/1
  # DELETE /medidas/1.json
  def destroy
    @medida.Estado = false
    if @medida.save
      respond_to do |format|
        format.html { redirect_to medidas_url, notice: 'Medida eliminada exitosamente.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to medidas_url, notice: 'Esta medida no se puede eliminar '+@medida.errors.messages[:base][0].to_s }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medida
      @medida = Medida.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def medida_params
      params.require(:medida).permit(:Nombre, :Estado, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
