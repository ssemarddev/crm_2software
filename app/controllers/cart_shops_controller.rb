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
    redirect_to online_catalog_path(phone: params[:phone])
  end

  def product_details
    @client = ClienteProveedor.find_by(Fax: params[:phone], Estado: true) if params[:phone] != nil
    @product ||= Producto.includes(:Marca).includes(:Medida).includes(:TipoProducto).includes(:product_image).find(params[:id])
    render 'product_details', layout: 'cart_shop_index'
  end

  def products_view
    producto = nil
    if params[:producto]!=nil && params[:producto] != ""
      producto = params[:producto]
    end

    categoria = nil
    if params[:categoria]!=nil && params[:categoria] != ""
      categoria = params[:categoria]
    end

    marca = nil
    if params[:marca]!=nil && params[:marca] != ""
      marca = params[:marca]
    end

    nit = nil
    if params[:nit]!=nil && params[:nit] != ""
      nit = params[:nit]
    end
    @productos ||= Producto
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

    if marca != nil && marca !=""
      @productos = @productos.where('"marcas"."id" = '+"'"+marca+"'")
    end

    @productos = @productos.paginate(page: params[:page], per_page: 12)
    if nit != nil && nit !=""
      nit =  nit.gsub("-", "")
    end

    render 'cart_shops/list', layout: 'layouts/cart_shop_index'
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
end