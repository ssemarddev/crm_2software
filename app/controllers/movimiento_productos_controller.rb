class MovimientoProductosController < ApplicationController
  before_action :set_movimiento_producto, only: [:show, :edit, :update, :destroy]

  # GET /movimiento_productos
  # GET /movimiento_productos.json
  def index
    @movimiento_productos = MovimientoProducto.all
  end

  # GET /movimiento_productos/1
  # GET /movimiento_productos/1.json
  def show
  end

  # GET /movimiento_productos/new
  def new
    @movimiento_producto = MovimientoProducto.new
  end

  # GET /movimiento_productos/1/edit
  def edit
  end

  # POST /movimiento_productos
  # POST /movimiento_productos.json
  def create
    params[:movimiento_producto][:creado_por]      = session[:user_id]
    params[:movimiento_producto][:actualizado_por] = session[:user_id]

    @movimiento_producto = MovimientoProducto.new(movimiento_producto_params)

    respond_to do |format|
      if @movimiento_producto.save
        format.html { redirect_to @movimiento_producto, notice: 'Movimiento producto was successfully created.' }
        format.json { render :show, status: :created, location: @movimiento_producto }
      else
        format.html { render :new }
        format.json { render json: @movimiento_producto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movimiento_productos/1
  # PATCH/PUT /movimiento_productos/1.json
  def update
    respond_to do |format|
      params[:movimiento_producto][:actualizado_por] = session[:user_id]
      if @movimiento_producto.update(movimiento_producto_params)
        format.html { redirect_to @movimiento_producto, notice: 'Movimiento producto was successfully updated.' }
        format.json { render :show, status: :ok, location: @movimiento_producto }
      else
        format.html { render :edit }
        format.json { render json: @movimiento_producto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movimiento_productos/1
  # DELETE /movimiento_productos/1.json
  def destroy
    @movimiento_producto.destroy
    respond_to do |format|
      format.html { redirect_to movimiento_productos_url, notice: 'Movimiento producto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movimiento_producto
      @movimiento_producto = MovimientoProducto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movimiento_producto_params
      params.require(:movimiento_producto).permit(:Producto_id, :Saliente_Bodega_id, :Entrante_Bodega_id, :cantidad, :porcentaje_proporcion, :movimiento_tipo, :signo, :Documento_id, :creado_por, :actualizado_por, :creado, :actualizado, :Estado, :porcentaje_ganancia)
    end
end
