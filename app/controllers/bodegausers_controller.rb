class BodegausersController < ApplicationController
  before_action :set_bodegauser, only: [:show, :edit, :update, :destroy]

  # GET /bodegausers
  # GET /bodegausers.json
  def index
    if params[:deleted]
      @bodegausers = Bodegauser.where(status:false)
    else
      @bodegausers = Bodegauser.where(status: true)
    end
  end

  # GET /bodegausers/1
  # GET /bodegausers/1.json
  def show
  end

  def saveChoose
    session[:bodega_id] = Bodega.find(params[:bodega]).id
    session[:bodega]    = Bodega.find(params[:bodega]).Nombre
    redirect_to admin_url
  end

  def chooseBodega
    @bodegas = Bodegauser.where(usuario_id:session[:user_id],status:true)
    if @bodegas.length > 1
      session[:user_url].push(chooseBodega_url)
      render 'bodegausers/elegirBodega' , layout: false
    elsif @bodegas.length == 1
      session[:bodega_id] = @bodegas[0].bodega.id
      session[:bodega]    = @bodegas[0].bodega.Nombre
      redirect_to admin_url
    else
      redirect_to admin_url
    end
  end
  # GET /bodegausers/new
  def new
    @bodegauser = Bodegauser.new
  end

  # GET /bodegausers/1/edit
  def edit
  end

  # POST /bodegausers
  # POST /bodegausers.json
  def create
    params[:bodegauser][:creado_por]      = session[:user_id]
    params[:bodegauser][:actualizado_por] = session[:user_id]
    @bodegauser = Bodegauser.new(bodegauser_params)

    respond_to do |format|
      if @bodegauser.save
        format.html { redirect_to bodegausers_url, notice: 'Bodegauser was successfully created.' }
        format.json { render :show, status: :created, location: @bodegauser }
      else
        format.html { render :new }
        format.json { render json: @bodegauser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bodegausers/1
  # PATCH/PUT /bodegausers/1.json
  def update
    respond_to do |format|
      params[:bodegauser][:actualizado_por] = session[:user_id]
      if @bodegauser.update(bodegauser_params)
        format.html { redirect_to bodegausers_url, notice: 'Bodegauser was successfully updated.' }
        format.json { render :show, status: :ok, location: @bodegauser }
      else
        format.html { render :edit }
        format.json { render json: @bodegauser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bodegausers/1
  # DELETE /bodegausers/1.json
  def destroy
    @bodegauser.status = false
    @bodegauser.save
    respond_to do |format|
      format.html { redirect_to bodegausers_url, notice: 'Bodegauser was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bodegauser
      @bodegauser = Bodegauser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bodegauser_params
      params.require(:bodegauser).permit(:bodega_id, :usuario_id, :status, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
