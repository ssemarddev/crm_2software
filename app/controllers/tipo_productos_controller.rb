class TipoProductosController < ApplicationController
  before_action :set_tipo_producto, only: [:show, :edit, :update, :destroy]

  # GET /tipo_productos
  # GET /tipo_productos.json
  def index
    if params[:deleted]
      @tipo_productos = TipoProducto.where(Estado:false)
    else
      @tipo_productos = TipoProducto.where(Estado: true)
    end
  end

  # GET /tipo_productos/1
  # GET /tipo_productos/1.json
  def show
  end

  # GET /tipo_productos/new
  def new
    @tipo_producto = TipoProducto.new
  end

  # GET /tipo_productos/1/edit
  def edit
  end

  # POST /tipo_productos
  # POST /tipo_productos.json
  def create
    params[:tipo_producto][:creado_por]      = session[:user_id]
    params[:tipo_producto][:actualizado_por] = session[:user_id]
    @tipo_producto = TipoProducto.new(tipo_producto_params)
    respond_to do |format|
      if @tipo_producto.save

        format.html { redirect_to tipo_productos_url, notice: 'Tipo producto was successfully created.' }
        format.json { render :show, status: :created, location: @tipo_producto }
      else
        format.html { render :new }
        format.json { render json: @tipo_producto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_productos/1
  # PATCH/PUT /tipo_productos/1.json
  def update
    respond_to do |format|
      params[:tipo_producto][:actualizado_por] = session[:user_id]
      if @tipo_producto.update(tipo_producto_params)
        format.html { redirect_to tipo_productos_url, notice: 'Tipo producto was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipo_producto }
      else
        format.html { render :edit }
        format.json { render json: @tipo_producto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_productos/1
  # DELETE /tipo_productos/1.json
  def destroy
    @tipo_producto.Estado = false
    if @tipo_producto.save
      respond_to do |format|
        format.html { redirect_to tipo_productos_url, notice: 'Tipo producto eliminado exitosamente.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to tipo_productos_url, notice: 'No se pudo eliminar este tipo de producto'+@tipo_producto.errors.messages[:base][0].to_s  }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_producto
      @tipo_producto = TipoProducto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipo_producto_params
      params.require(:tipo_producto).permit(:Nombre, :Es_Servicio, :Estado, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
