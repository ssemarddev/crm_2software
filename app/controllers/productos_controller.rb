require 'rqrcode'
class ProductosController < ApplicationController
  before_action :set_producto, only: %i[show edit update destroy]
  before_action :generate_qr, only: %i[show edit]

  def generate_qr
    @qr = RQRCode::QRCode.new(@producto.Codigo.to_s, size: 1, level: :h)
  end

  def self.get_product_stock(product, bodega)
    if !bodega.nil?
      entradas = MovimientoProducto.where(Producto_id: product, Entrante_Bodega_id: bodega, Estado: true, status: 1)
      salidas  = MovimientoProducto.where(Producto_id: product, Saliente_Bodega_id: bodega, Estado: true, status: 1)
    else
      entradas = MovimientoProducto.where(Producto_id: product, Estado: true, status: 1, movimiento_tipo: 1)
      salidas  = MovimientoProducto.where(Producto_id: product, Estado: true, status: 1, movimiento_tipo: 2)
    end
    unidades = 0
    entradas.each do |entrada|
      next if entrada.porcentaje_proporcion.nil?

      unidades += if entrada.porcentaje_proporcion != 100
                    (entrada.cantidad * (entrada.porcentaje_proporcion / 100)).to_f
                  else
                    entrada.cantidad
                  end
    end
    
    salidas.each do |salida|
      next if salida.porcentaje_proporcion.nil?

      unidades -= if salida.porcentaje_proporcion != 100
                    (salida.cantidad * (salida.porcentaje_proporcion / 100)).to_f
                  else
                    salida.cantidad
                  end
    end
    unidades
  end

  def online_catalog
    @productos = Producto.where(deleted_at: nil)

    if params[:search].present?
      @productos = @productos.where("nombre ILIKE ?", "%#{params[:search]}%")
    end

    @productos = @productos.order(:id).paginate(page: params[:page], per_page: 20)
  end

  # GET /productos
  # GET /productos.json
  def index
    params[:nombre_producto] = '%'.concat(params[:nombre_producto]).concat('%') if params[:nombre_producto]
    params[:nombre_producto] = '%%' unless params[:nombre_producto]
    if params[:deleted]
      @productos = Producto.where('UPPER("productos"."Nombre") like UPPER(' + "'%" + params[:nombre_producto] + "%'" + ')').where(estado: false).or(
        Producto.where('UPPER("productos"."Codigo") like UPPER(' + "'%" + params[:nombre_producto] + "%'" + ')')
      ).paginate(
        page: params[:page], per_page: 10
      )
    else
      @productos = Producto.where('UPPER("productos"."Nombre") like UPPER(' + "'%" + params[:nombre_producto] + "%'" + ')').where(estado: true).or(
        Producto.where('UPPER("productos"."Codigo") like UPPER(' + "'%" + params[:nombre_producto] + "%'" + ')')
      ).paginate(
        page: params[:page], per_page: 10
      )
    end
  end

  # GET /productos/1
  # GET /productos/1.json
  def show; end

  # GET /productos/new
  def new
    @producto = Producto.new
  end

  # GET /productos/1/edit
  def edit
    @edit = true
  end

  # POST /productos
  # POST /productos.json
  def create
    codigo = Producto.maximum('Codigo').nil? ? 0o001 : Producto.all.order('CAST ( "id" AS integer ) desc').first.Codigo.to_i + 1
    params[:producto][:Codigo] = codigo
    params[:producto][:creado_por]      = session[:user_id]
    params[:producto][:actualizado_por] = session[:user_id]
    params[:producto][:estado] = true
    imagenes = params[:dropImage]
    @producto = Producto.new(producto_params)
    respond_to do |format|
      if @producto.save
        if imagenes
          imagenes.each do |imagen|
            @productoImagenes = ProductImage.new
            @productoImagenes.Producto = @producto
            @productoImagenes.nombre = imagen.original_filename
            @productoImagenes.descripcion = imagen.original_filename
            next unless @productoImagenes.save && imagenes

            uploaded_io = imagen
            File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
              file.write(uploaded_io.read)
            end
          end
        end
        format.html { redirect_to new_producto_path, notice: 'Producto was successfully created.' }
        format.json { render :show, status: :created, location: @producto }
      else
        format.html { render :new }
        format.json { render json: @producto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /productos/1
  # PATCH/PUT /productos/1.json
  def update
    respond_to do |format|
      params[:producto][:actualizado_por] = session[:user_id]
      params[:producto][:estado] = true
      imagenes = params[:dropImage]
      if @producto.update(producto_params)
        if imagenes
          imagenes.each do |imagen|
            @productoImagenes = ProductImage.new
            @productoImagenes.Producto = @producto
            @productoImagenes.nombre = imagen.original_filename
            @productoImagenes.descripcion = imagen.original_filename
            next unless @productoImagenes.save && imagenes

            uploaded_io = imagen
            File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
              file.write(uploaded_io.read)
            end
          end
        end
        if params[:deletedImgs]
          deletedImg = params[:deletedImgs]
          deletedImg.each do |imagen|
            @productoImagenes = ProductImage.find(imagen)
            @productoImagenes.destroy
          end
        end
        format.html { redirect_to @producto, notice: 'Producto was successfully updated.' }
        format.json { render :show, status: :ok, location: @producto }
      else
        format.html { render :edit }
        format.json { render json: @producto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /productos/1
  # DELETE /productos/1.json
  def destroy
    @producto.estado = false
    @producto.save
    respond_to do |format|
      format.html { redirect_to productos_url, notice: 'Producto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_producto
    @producto = Producto.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def producto_params
    params.require(:producto).permit(:Codigo, :Nombre, :Marca_id, :ClienteProveedor_id, :TipoProducto_id, :Minimos,
                                     :Valor_Compra, :Valor_Venta, :Medida_id, :Fila, :Columna, :dropImage, :deletedImgs, :estado, :preciouno, :preciodos, :preciotres, :preciocuatro)
  end
end
