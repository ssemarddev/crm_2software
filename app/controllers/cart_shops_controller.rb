class CartShopsController < ApplicationController
  skip_before_action :authorize
  before_action :set_categories, only: %i[product_details products_view cart_shop_login]


  def set_categories
    @categoriasCatalogo = TipoProducto.where(Estado: true)
    @marcas = Marca.where(Estado: true)
    @empresa = Empresa.find(1)
  end

  def cart_shop_login
    render 'login', layout: 'cart_shop_index'
  end
  
 def login_as_client
  phone = params[:phone].to_s.gsub(/\D/, '')

  if phone.present?
    usuario = Usuario.find_by(Telefono: phone.to_i, Estado: true) ||
              Usuario.find_by(Telefono1: phone.to_i, Estado: true)

    if usuario.present?
      session[:catalog_phone] = phone
      session[:catalog_user_id] = usuario.id
      redirect_to online_catalog_path, notice: "Sesión iniciada correctamente."
    else
      session[:catalog_phone] = nil
      session[:catalog_user_id] = nil
      redirect_to cart_shop_login_path, alert: "No encontramos un usuario con ese número."
    end
  else
    session[:catalog_phone] = nil
    session[:catalog_user_id] = nil
    redirect_to online_catalog_path, notice: "Ingresaste sin login."
  end
end

  def product_details
  phone = session[:catalog_phone].presence || params[:phone].presence

  @catalog_user =
    if session[:catalog_user_id].present?
      Usuario.find_by(id: session[:catalog_user_id], Estado: true)
    elsif phone.present?
      Usuario.find_by(Telefono: phone.to_i, Estado: true) ||
      Usuario.find_by(Telefono1: phone.to_i, Estado: true)
    end

  @client =
    if phone.present?
      ClienteProveedor.find_by(Fax: phone, Estado: true)
    end

  @product = Producto
    .includes(:Marca, :Medida, :TipoProducto, :product_image)
    .find(params[:id])

  @stock = ProductosController.get_product_stock(@product.id, nil)

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
    .order('"productos"."Nombre" ASC')
    .paginate(page: params[:page], per_page: 20)

    if request.xhr?
      render partial: 'cart_shops/catalog_results', locals: { productos: @productos }
    else
    @productos = @productos.paginate(page: params[:page], per_page: 12)

      @catalog_user =
        if session[:catalog_user_id].present?
          Usuario.find_by(id: session[:catalog_user_id], Estado: true)
        elsif session[:catalog_phone].present?
          Usuario.find_by(Telefono: session[:catalog_phone].to_i, Estado: true) ||
          Usuario.find_by(Telefono1: session[:catalog_phone].to_i, Estado: true)
        end

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

  def catalog_logout
  session.delete(:catalog_phone)
  session.delete(:catalog_user_id)

  redirect_to online_catalog_path, notice: 'Sesión cerrada correctamente.'
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

  def create_restock_request
  @product = Producto.find(params[:id])

  solicitud_existente = SolicitudResurtido.where(
    Producto_id: @product.id,
    Estado: true,
    status: 1
  ).first

  if solicitud_existente.present?
    redirect_to "/product_details/#{@product.id}?phone=#{params[:phone]}", alert: 'Este producto ya tiene una solicitud de resurtido pendiente.'
    return
  end

  solicitud = SolicitudResurtido.new
  solicitud.Producto_id = @product.id
  solicitud.cantidad_sugerida = params[:cantidad_sugerida].to_i > 0 ? params[:cantidad_sugerida].to_i : 1
  solicitud.telefono_solicitante = params[:phone]
  solicitud.comentario = params[:comentario]
  solicitud.solicitado_por = session[:user_id]
  solicitud.creado_por = session[:user_id]
  solicitud.actualizado_por = session[:user_id]
  solicitud.Estado = true
  solicitud.status = 1

  if solicitud.save
    redirect_to "/product_details/#{@product.id}?phone=#{params[:phone]}", notice: 'La solicitud de resurtido fue enviada correctamente.'
  else
    redirect_to "/product_details/#{@product.id}?phone=#{params[:phone]}", alert: 'No fue posible generar la solicitud de resurtido.'
  end
end
end