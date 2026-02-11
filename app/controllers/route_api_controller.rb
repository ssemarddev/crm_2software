class RouteApiController < ApplicationController
  skip_before_action :authorize
  def loginApi
     user = Usuario.find_by(User_Name: params[:User_Name], :Estado => true)
     # If the user exists AND the password entered is correct.
     if user && user.authenticate(params[:password])
       # Save the user id inside the browser cookie. This is how we keep the user
       # logged in when they navigate around our website.
     render json: '{ "statusCode": 200, "description":"Bienvenido.", "id":"'+user.id.to_s+'","nombre":"'+user.Nombres.to_s+'" }'
     # If user's login doesn't work, send them back to the login form.
     # redirect_to '/login'
     else
       render json: '{ "statusCode": 401, "description" : "Credenciales Invalidas." }'
     end
  end

  def listDefinedRoutes
    #@rutas = Rutum.where(/*status: true,*/ tipo: 1)
    @rutas = Rutum.where(tipo: 1)
    render json:'{ "statusCode": 200, "description":"Ok", "data":'+@rutas.to_json+'}'
  end

  def findClientsByRoute
    @cliente_proveedors = ClienteProveedor.where(Estado:true, Tipo: 1, ruta_id: params[:route_id])
    render json:'{ "statusCode": 200, "description":"Ok", "data":'+@cliente_proveedors.to_json+'}'
  end

  def listProducts
    @products = Producto.where(estado:true)
    render json:'{ "statusCode": 200, "description":"Ok", "data":'+@products.to_json+'}'
  end

  def listSizesByProduct
    @product  = Producto.find(params[:productId])
    @medida   = Medida.find(@product.Medida_id.to_i)
    @medidas  = []
    @medidas.push({ :id => "m-"+@medida.id.to_s, :name => @medida.Nombre.to_s })
    @detalles = DetalleMedida.where(Medida_id: @medida.id)
    @detalles.each do |d|
      @medidas.push({ :id => "dm-"+d.id.to_s, :name => d.Nombre.to_s })
    end
    render json:'{ "statusCode": 200, "description":"Ok", "data":'+@medidas.to_json+'}'
  end

  def saveRouteOrder
    details = params[:detailsProds]
    @cliente   = ClienteProveedor.find_by(:nit => params[:nit])
    @numDoc    = Documento.maximum("Documento") == nil ? 0001 : Documento.all.order('CAST ( "Documento" AS integer ) desc').first.Documento.to_i + 1
    @tDocto    = TipoDocumento.find(2)#params[:tipo])
    @tPago     = TipoPago.find(1)
    @usuario   = Usuario.find_by(id: params[:user_id])
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
      #d = JSON.parse(d)
      @producto   = Producto.find_by(:id  => d["product"])
      @detalle_documento = DetalleDocumento.new
      @detalle_documento.Documento = @documento
      @detalle_documento.Producto  = @producto
      if (d[:size].split("-"))[0] == "md"
        @detalle_medida            = DetalleMedida.find_by(:id => params[:detalle_unidad_medida])
        @detalle_documento.DetalleMedida = @detalle_medida
      else
        @medida            = Medida.find_by(:id => d[:medida])
        @detalle_documento.Medida        = @medida
      end

      @detalle_documento.cantidad        = d[:cantidad]
      @detalle_documento.descripcion     = @producto.Nombre
      @detalle_documento.valor_compra    = @producto.Valor_Compra
      @detalle_documento.valor_venta     = @producto.Valor_Venta
      @detalle_documento.descuento       = 0
      @detalle_documento.descuento_porcentaje = @cliente.Porcentaje_Comision
      @detalle_documento.total           = @producto.Valor_Venta.to_f * d["cantidad"].to_f
      @detalle_documento.estado          = false
      @detalle_documento.creado_por      = session[:user_id]
      @detalle_documento.actualizado_por = session[:user_id]
      @detalle_documento.status          = 2
      @detalle_documento.save

      @movimiento = MovimientoProducto.new
      @movimiento.Producto              = @producto
      @movimiento.Saliente_Bodega       = @bodegaSaliente
      @movimiento.Entrante_Bodega       = nil
      @movimiento.Documento             = @documento
      @movimiento.detalle_documento_id  = @detalle_documento.id
      @movimiento.creado_por            = params[:user_id]
      @movimiento.actualizado_por       = params[:user_id]
      @movimiento.signo                 = "-"
      @movimiento.cantidad              = d[:cantidad]
      @movimiento.Estado                = false
      @movimiento.porcentaje_proporcion = d[:proporcion]
      @movimiento.movimiento_tipo       = 2
      @movimiento.porcentaje_ganancia   = d[:ganancia]
      @movimiento.status                = 2
      @movimiento.save
    end


    render json: [@detalle_documento,@documento,@cliente ]

  end
end
