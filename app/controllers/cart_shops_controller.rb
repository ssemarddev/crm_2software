class CartShopsController < ApplicationController
  skip_before_action :authorize
  before_action :set_categories, only: %i[product_details products_view cart_shop_login]
  before_action :authorize, only: %i[save_catalog_restock]

  def set_categories
    @categoriasCatalogo = TipoProducto.where(Estado: true)
    @marcas = Marca.where(Estado: true)
    @empresa = Empresa.find(1)
  end

  def cart_shop_login
    render 'login', layout: 'cart_shop_index'
  end
  
  def login_as_client
    redirect_to online_catalog_path(phone: params[:phone])
  end

  def product_details
  @client = ClienteProveedor.find_by(Fax: params[:phone], Estado: true) if params[:phone] != nil
  @product ||= Producto.includes(:Marca).includes(:Medida).includes(:TipoProducto).includes(:product_image).find(params[:id])
  @stock = ProductosController.get_product_stock(@product.id, nil)
  @bodegas = Bodega.where(Estado: true).order(:Nombre)
  render 'product_details', layout: 'cart_shop_index'
  end

  def products_view
    @categorias = TipoProducto.all
    @marcas = Marca.all

    @productos ||= Producto
      .joins('LEFT JOIN Marcas "marcas" ON "marcas"."id" = "productos"."Marca_id"')
      .joins('LEFT JOIN Tipo_Productos "tp" ON "tp"."id" = "productos"."TipoProducto_id"')
      .joins('LEFT JOIN Medidas "medidas" ON "medidas"."id" = "productos"."Medida_id"')
      .joins('LEFT JOIN movimiento_productos "mp" ON "mp"."Producto_id" = "productos"."id"')
      .select(%Q(
        "productos"."id",
        "productos"."Codigo",
        "productos"."Nombre",
        "marcas"."Nombre" as "MarcaNombre",
        "medidas"."Nombre" as "MedidaNombre",
        "productos"."Valor_Venta",
        COALESCE(
          SUM(
            CASE
              WHEN "mp"."signo" = '+' THEN "mp"."cantidad"
              WHEN "mp"."signo" = '-' THEN -"mp"."cantidad"
              ELSE 0
            END
          ), 0
        ) as "StockTotal"
      ))
      .where(estado: true)

    if params[:producto].present?
      @productos = @productos.where('"productos"."Nombre" ILIKE ?', "%#{params[:producto]}%")
    end

    if params[:categoria].present?
      @productos = @productos.where('"productos"."TipoProducto_id" = ?', params[:categoria])
    end

    if params[:marca].present?
      @productos = @productos.where('"productos"."Marca_id" = ?', params[:marca])
    end

    @productos = @productos
      .group(%Q(
        "productos"."id",
        "productos"."Codigo",
        "productos"."Nombre",
        "marcas"."Nombre",
        "medidas"."Nombre",
        "productos"."Valor_Venta"
      ))
      .paginate(page: params[:page], per_page: 20)

    if request.xhr?
      render partial: 'cart_shops/catalog_results', locals: { productos: @productos }
    else
      render 'cart_shops/list', layout: 'layouts/cart_shop_index'
    end
  end

  def productosView2
    producto = nil
    if params[:producto]!=nil && params[:producto] != ""
      producto = params[:producto]
    end
    categoria = nil
    if params[:categoria]!=nil && params[:categoria] != ""
      categoria = params[:categoria]
    end
    nit = nil
    if params[:nit]!=nil && params[:nit] != ""
      nit = params[:nit]
    end
    @productos = Producto
    .joins('LEFT JOIN Marcas "marcas" ON "marcas"."id" = "productos"."Marca_id"')
    .joins('LEFT JOIN Tipo_Productos "tp" ON "tp"."id" = "productos"."TipoProducto_id"')
    .joins('LEFT JOIN Medidas "medidas" ON "medidas"."id" = "productos"."Medida_id"')
    .select('"productos"."id","productos"."Codigo","productos"."Nombre","marcas"."Nombre" as "MarcaNombre","medidas"."Nombre" as "MedidaNombre","Valor_Venta"')
    .where(estado:true)
    if producto != nil && producto !=""
      @productos = @productos.where('UPPER("productos"."Nombre") like UPPER('+"'%"+producto+"%'"+')')
    end
    if categoria != nil && categoria !=""
      @productos = @productos.where('"tp"."id" = '+"'"+categoria+"'")
    end

    @productos = @productos.paginate(page: params[:page], per_page: 10)
    if nit != nil && nit !=""
      nit =  nit.gsub("-", "")
      @descuento = ClienteProveedor.where('"cliente_proveedors"."nit"='+"'"+nit.to_s+"'").where(Estado: true)
      if !@descuento
        nit = nil
        @descuento= nil
      else
        if @descuento.length < 1
          @descuento= nil
        end
      end
    end
    render 'productosV2', layout: true
  end


  def saveCartOrder
    details =  JSON.parse(params[:detailsProds])
    @cliente   = ClienteProveedor.find_by(:nit => params[:nit])
    if !@cliente
      @cliente = ClienteProveedor.new
      @cliente.Nombre           = params[:cliente]
      @cliente.Destino          = 1
      @cliente.Fax              = params[:telefono]
      @cliente.nit              = params[:nit]
      @cliente.direccion        = params[:direccionFacturacion]
      @cliente.creado_por       = session[:user_id]
      @cliente.actualizado_por  = session[:user_id]
      @cliente.Estado           = true
      @cliente.save
    end
    @numDoc    = Documento.maximum("Documento") == nil ? 0001 : Documento.all.order("CAST ( Documento AS integer ) desc").first.Documento.to_i + 1
    @tDocto    = TipoDocumento.find(2)#params[:tipo])
    @tPago     = TipoPago.find(1)
    @usuario   = Usuario.find_by(id: session[:user_id])
    @documento = Documento.new
    @documento.Fecha_Entrega     = nil #Time.now.strftime("%Y-%m-%d %H:%M:%S")
    @documento.Fecha_Recibido    = nil #Time.now.strftime("%Y-%m-%d %H:%M:%S")
    @documento.Documento         = @numDoc
    @documento.Serie             = 0
    @documento.Factura           = 0
    @documento.ClienteProveedor  = @cliente
    @documento.TipoPago          = @tPago
    @documento.TipoDocumento     = @tDocto
    @documento.Usuario_enviado   = @usuario
    @documento.Usuario_recibido  = @usuario
    @documento.Estado            = false
    @documento.status            = 2 # Pendiente despacho
    @documento.creado_por        = session[:user_id]
    @documento.actualizado_por   = session[:user_id]
    @documento.save
    details.each do |d|
      d = JSON.parse(d)
      @producto   = Producto.find_by(:id  => d["product"])
      @detalle_documento = DetalleDocumento.new
      @detalle_documento.Documento = @documento
      @detalle_documento.Producto  = @producto
      if params[:proporcion].to_f < 100
        @detalle_medida            = DetalleMedida.find_by(:id => params[:detalle_unidad_medida])
        @detalle_documento.DetalleMedida = @detalle_medida
      else
        @medida            = Medida.find_by(:id => d[:medida])
        @detalle_documento.Medida        = @medida
      end

      @detalle_documento.cantidad        = d["cantidad"]
      @detalle_documento.descripcion     = @producto.Nombre
      @detalle_documento.valor_compra    = @producto.Valor_Compra
      @detalle_documento.valor_venta     = @producto.Valor_Venta
      @detalle_documento.descuento       = 0
      @detalle_documento.descuento_porcentaje = @cliente.Porcentaje_Comision
      @detalle_documento.total           = @producto.Valor_Venta.to_f * d["cantidad"].to_f
      @detalle_documento.estado          = false
      @detalle_documento.creado_por      = session[:user_id]
      @detalle_documento.actualizado_por = session[:user_id]
      @detalle_documento.status          = 1
      @detalle_documento.save
    end
    @tracking = Tracking.news
    @tracking.numero =  Tracking.maximum("numero") == nil ? 0001 :   Tracking.all.order("CAST ( numero AS integer ) desc").first.numero.to_i + 1
    @tracking.descripcion = ""
    @tracking.direccionOrigen  = ""
    @tracking.direccionDestion = params[:direccionEntrega]
    @tracking.cliente_proveedor = @cliente
    @tracking.estado =  Estado.find(8)
    @tracking.state =  true
    @tracking.save

    @estado = Estadortacking.new
    @estado.tracking = @tracking
    @estado.estado   = @tracking.estado
    @estado.comentario = ""
    @estado.creado_por = session[:user_id]
    @estado.actualizado_por = session[:user_id]
    @estado.status = true
    @estado.save

    require 'rqrcode'
    @qr = RQRCode::QRCode.new(@tracking.numero.to_s, :size => 1, :level => :h )
    @estados = Estadortacking.where(:tracking => @tracking.id)
    #render json[@detalle_documento,@documento,@cliente ]
    render 'tracking', layout:false
  end
  def save_catalog_restock
    @product = Producto.find(params[:product_id])
    @phone = params[:phone]

    cantidad = params[:cantidad].to_f
    porcentaje_proporcion = params[:porcentaje_proporcion].present? ? params[:porcentaje_proporcion].to_f : 100
    bodega_entrante = Bodega.find_by(id: params[:bodega_entrante_id])

    if bodega_entrante.nil?
      redirect_to "/product_details/#{@product.id}?phone=#{@phone}", alert: 'Debes seleccionar una bodega.'
      return
    end

    if cantidad <= 0
      redirect_to "/product_details/#{@product.id}?phone=#{@phone}", alert: 'La cantidad debe ser mayor a 0.'
      return
    end

    tipo_documento = TipoDocumento.find_by(id: 1)
    tipo_pago = TipoPago.find_by(id: 1)

    if tipo_documento.nil?
      redirect_to "/product_details/#{@product.id}?phone=#{@phone}", alert: 'No existe el TipoDocumento con id 1.'
      return
    end

    numero_documento = if Documento.maximum("Documento").nil?
                        1
                      else
                        Documento.all.order('CAST("Documento" AS integer) DESC').first.Documento.to_i + 1
                      end

    documento = Documento.new
    documento.Fecha_Entrega    = Time.now.strftime('%Y-%m-%d')
    documento.Fecha_Recibido   = Time.now.strftime('%Y-%m-%d')
    documento.Documento        = numero_documento
    documento.Serie            = 0
    documento.Factura          = 0
    documento.ClienteProveedor = nil
    documento.TipoDocumento    = tipo_documento
    documento.TipoPago         = tipo_pago
    documento.Usuario_enviado  = Usuario.find_by(id: session[:user_id])
    documento.Usuario_recibido = Usuario.find_by(id: session[:user_id])
    documento.Estado           = true
    documento.status           = 1
    documento.creado_por       = session[:user_id]
    documento.actualizado_por  = session[:user_id]

    unless documento.save
      redirect_to "/product_details/#{@product.id}?phone=#{@phone}", alert: 'No fue posible crear el documento de resurtido.'
      return
    end

    detalle_documento = DetalleDocumento.new
    detalle_documento.Documento              = documento
    detalle_documento.Producto               = @product
    detalle_documento.Medida                 = @product.Medida
    detalle_documento.cantidad               = cantidad
    detalle_documento.descripcion            = params[:descripcion].presence || "Resurtido manual desde catálogo"
    detalle_documento.valor_compra           = @product.Valor_Compra
    detalle_documento.valor_venta            = @product.Valor_Venta
    detalle_documento.descuento              = 0
    detalle_documento.descuento_porcentaje   = 0
    detalle_documento.total                  = (@product.Valor_Compra.to_f * cantidad.to_f)
    detalle_documento.estado                 = true
    detalle_documento.creado_por             = session[:user_id]
    detalle_documento.actualizado_por        = session[:user_id]
    detalle_documento.status                 = 1

    unless detalle_documento.save
      redirect_to "/product_details/#{@product.id}?phone=#{@phone}", alert: 'No fue posible crear el detalle del resurtido.'
      return
    end

    movimiento = MovimientoProducto.new
    movimiento.Producto              = @product
    movimiento.Saliente_Bodega       = nil
    movimiento.Entrante_Bodega       = bodega_entrante
    movimiento.Documento             = documento
    movimiento.detalle_documento_id  = detalle_documento.id
    movimiento.cantidad              = cantidad
    movimiento.porcentaje_proporcion = porcentaje_proporcion
    movimiento.movimiento_tipo       = 1
    movimiento.signo                 = '+'
    movimiento.creado_por            = session[:user_id]
    movimiento.actualizado_por       = session[:user_id]
    movimiento.Estado                = true
    movimiento.porcentaje_ganancia   = 0
    movimiento.status                = 1

    unless movimiento.save
      redirect_to "/product_details/#{@product.id}?phone=#{@phone}", alert: 'No fue posible guardar el movimiento de inventario.'
      return
    end

    redirect_to "/product_details/#{@product.id}?phone=#{@phone}", notice: 'Producto resurtido correctamente.'
  end
end