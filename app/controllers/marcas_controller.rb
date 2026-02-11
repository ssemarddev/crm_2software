class MarcasController < ApplicationController
  #respond_to :html, :json
  #before_action  only: [:show, :index] do
  #  authorize_module(7)
  #end
  before_action :set_marca, only: [:show, :edit, :update, :destroy]
  # GET /marcas
  # GET /marcas.json
  def index
    if params[:deleted]
      @marcas = Marca.where(Estado:false)
    else
      @marcas = Marca.where(Estado: true)
    end
  end

  # GET /marcas/1
  # GET /marcas/1.json
  def show
  end

  # GET /marcas/new
  def new
    @marca = Marca.new
  end

  # GET /marcas/1/edit
  def edit
  end

  # POST /marcas
  # POST /marcas.json
  def create
    params[:marca][:creado_por]      = session[:user_id]
    params[:marca][:actualizado_por] = session[:user_id]
    @marca = Marca.new(marca_params)
    respond_to do |format|
      if @marca.save
        format.html { redirect_to marcas_url, notice: 'Marca was successfully created.' }
        format.json { render :show, status: :created, location: @marca }
      else
        format.html { render :new }
        format.json { render json: @marca.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /marcas/1
  # PATCH/PUT /marcas/1.json
  def update
    respond_to do |format|
      params[:marca][:actualizado_por] = session[:user_id]
      if @marca.update(marca_params)
        format.html { redirect_to marcas_url, notice: 'Marca was successfully updated.' }
        format.json { render :show, status: :ok, location: @marca }
      else
        format.html { render :edit }
        format.json { render json: @marca.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /marcas/1
  # DELETE /marcas/1.json
  def destroy
    @marca.Estado = false
    if @marca.save
      respond_to do |format|
        format.html { redirect_to marcas_url, notice: 'Marca eliminada exitosamente.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to marcas_url, notice: 'Esta marca no se pudo eliminar '+@marca.errors.messages[:base][0].to_s }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_marca
      @marca = Marca.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def marca_params
      params.require(:marca).permit(:Nombre, :Estado, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
