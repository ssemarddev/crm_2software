class PuntoventaController < ApplicationController
  # Documentos 1= compra 2= venta, 3= envios
  def new
    @documento = Documento.new
    @rutas = Rutum.where(status: true, tipo: 2)
    @clientes = ClienteProveedor.where(Estado: true, Tipo: 1)
    @productos_list ||= Producto.where(estado: true)
  end

  def cotizacion
    @documento = Documento.includes(:detalle_documento).includes(:movimiento_producto).find_by(Documento: params[:id])
    @total_orden = @documento.detalle_documento.to_a.inject(0) { |sum, hash| sum += hash[:valor_venta]*hash[:cantidad] }
    @rutas = Rutum.where(status: true, tipo: 2)
    @clientes = ClienteProveedor.where(Estado: true, Tipo: 1, id: @documento.ClienteProveedor)
    @productos_list ||= Producto.where(estado: true)

    render 'puntoventa/new'
  end

  def puntoventaMiniSuper
    @rutas = Rutum.where(status: true, tipo: 2)
    @clientes = ClienteProveedor.where(Estado: true, Tipo: 1)
    render 'puntoventa/puntoventaMiniSuper'
  end

  def compra
    render 'puntoventa/compra'
  end

  def create; end

  def printDocumento
    require 'rqrcode'
    @documento = Documento.where(Documento: params[:id])
    @documento = @documento[0]
    @detalleDocumento = DetalleDocumento.where(Documento: @documento)
    @qr = RQRCode::QRCode.new(@documento.id.to_s, size: 1, level: :h)
    render 'puntoventa/print'
  end

  skip_before_action :authorize
  def getStockProduct
    @entradas = MovimientoProducto.where(Producto_id: params[:Producto_id], Estado: true, status: 1, signo: '+')
    @salidas  = MovimientoProducto.where(Producto_id: params[:Producto_id], Estado: true, status: 1, signo: '-')
    @unidades = 0
    productoBodegas = {}
    @entradas.each do |entrada|
      unless entrada.porcentaje_proporcion.nil?
        @unidades = if entrada.porcentaje_proporcion != 100
                      (entrada.cantidad * (entrada.porcentaje_proporcion / 100)).to_f
                    else
                      entrada.cantidad
                    end
      end
      bodega = Bodega.find_by(id: entrada.Entrante_Bodega_id)
      unless bodega.nil?
        productoBodegas[bodega.Nombre] =
          (productoBodegas.include?(bodega.Nombre) ? productoBodegas[bodega.Nombre] : 0) + @unidades.to_f
      end
    end

    @salidas.each do |salida|
      unless salida.porcentaje_proporcion.nil?
        @unidades = if salida.porcentaje_proporcion != 100
                      (salida.cantidad * (salida.porcentaje_proporcion / 100)).to_f
                    else
                      salida.cantidad
                    end
      end

      bodega = Bodega.find_by(id: salida.Saliente_Bodega_id)
      unless bodega.nil?
        productoBodegas[bodega.Nombre] =
          (productoBodegas.include?(bodega.Nombre) ? productoBodegas[bodega.Nombre] : 0) - @unidades.to_f
      end
    end
    render json: productoBodegas
  end

  documento = 0
  def findProduct
    @product = Producto.where(Codigo: params[:product], estado: true)
    # @product  = Producto.where(id: params[:product])

    if !params[:tipo].nil?
      bodega = params[:bodega] if params[:tipo].to_i == 1 || params[:tipo].to_i == 3 # 1= compra, 3= envios
    else
      bodega = session[:bodega_id]
    end

    @unidades = ProductosController.get_product_stock @product, bodega

    @product  = [@product, {
      'unidades' => @unidades, 'esServicio' => TipoProducto.find(@product[0].TipoProducto_id).Es_Servicio
    }]
    render json: @product
  end

  def findProductoByProvider
    @product ||= if params[:proveedor].to_s != 'all'
                   Producto.where(ClienteProveedor: params[:proveedor], estado: true)
                 else
                   Producto.where(estado: true).joins('INNER JOIN "marcas" m ON m."id"= "productos"."Marca_id"').select(
                     '"productos"."ClienteProveedor_id",
        "productos"."Codigo",
        "productos"."Columna",
        "productos"."Fila",
        "productos"."Marca_id",
        "productos"."Medida_id",
        "productos"."Minimos",
        "productos"."Nombre",
        "productos"."TipoProducto_id",
        "productos"."Valor_Compra",
        "productos"."Valor_Venta",
        "productos"."created_at",
        "productos"."estado",
        "productos"."id",
        "productos"."link",
        "productos"."updated_at",
        "m"."Nombre" as marca'
                   ).order('"productos"."Nombre"')
                 end
    render json: @product
  end

  def findMedida
    @medida = Medida.where(id: params[:medida], Estado: true)
    render json: @medida
  end

  def findDocumento
    @documento = Documento.where(id: params[:medida], Estado: true)
    render json: @documento
  end

  def findDetalleMedida
    @medida = DetalleMedida.where(Medida_id: params[:medida])
    render json: @medida
  end

  def findCliente
    @cliente = ClienteProveedor.where(nit: params[:nit], Estado: true)
    render json: @cliente
  end

  def findProveedor
    @proveedor = ClienteProveedor.where(Estado: true, Tipo: 2)
    render json: @proveedor
  end

  def findBodegas
    @bodegas = Bodega.where(Estado: true).joins('LEFT JOIN Usuarios "usuarios" ON "usuarios"."id" = "bodegas"."Usuario_id"').select('"usuarios"."Nombres" as user, "bodegas"."Nombre" as bodega, "bodegas"."id" as id')
    render json: @bodegas
  end

  def findFactura
    @factura = AutoSat.where(Bodega: session[:bodega_id], Estado: true)
    render json: @factura
  end

  def findTipoPago
    @tipoPago = TipoPago.where(Estado: true)
    render json: @tipoPago
  end

  def saveMovProduct
    if params[:documento].to_i < 1
      params[:nit] = 'CF' if params[:nit] == 'cf'
      @numDoc = Documento.maximum('Documento').nil? ? 00001 : Documento.all.order('"Documento" desc').first.Documento.to_i + 1
      unless params[:tipo].nil?
        @cliente   = params[:proveedor] ? ClienteProveedor.where(id: params[:proveedor]) : ClienteProveedor.where(nit: params[:nit])
        @tPago     = TipoPago.where(id: params[:tipo_pago])
      end

      @tDocto    = TipoDocumento.where(id: params[:tipo]) # params[:tipo])
      @usuario   = Usuario.find_by(id: session[:user_id])
      @documento = Documento.new
      @documento.Fecha_Entrega     = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      @documento.Fecha_Recibido    = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      @documento.Documento         = @numDoc
      @documento.Serie             = 0
      @documento.Factura           = 0
      @documento.ClienteProveedor  = @cliente.first
      @documento.TipoPago          = @tPago.first
      @documento.TipoDocumento     = @tDocto.first
      @documento.Usuario_enviado   = @usuario
      @documento.Usuario_recibido  = @usuario
      @documento.Estado            = false
      @documento.status            = 1
      @documento.creado_por        = session[:user_id]
      @documento.actualizado_por   = session[:user_id]

      documento = if @documento.save
                    @documento.Documento
                  # render json:true
                  else
                    0
                    # abort(documento.to_s)
                    # render json:@documento
                  end
    else
      documento = params[:documento]
    end
    @bodegaEntrante = nil
    @bodegaSaliente = nil

    if params[:tipo].to_i == 2 || params[:tipo].to_i == 4
      @bodegaEntrante = nil
      @bodegaSaliente = Bodega.find_by(id: session[:bodega_id])
    elsif params[:tipo].to_i == 3
      @bodegaEntrante = nil
      @bodegaSaliente = Bodega.find_by(id: session[:bodega_id])
    elsif params[:tipo].to_i == 1
      @bodegaEntrante = Bodega.find_by(id: params[:bodegaEntranteId])
      @bodegaSaliente = nil
    else
      @bodegaEntrante = nil
      @bodegaSaliente = nil
    end

    @producto   = Producto.find_by(id: params[:producto])
    @documento  = Documento.find_by(Documento: documento)
    if !params[:tipo].nil?
      if params[:tipo].to_i == 2 || params[:tipo].to_i == 4 # 1= compra 2= venta, 3= envios
        bodega = session[:bodega_id]
      elsif params[:tipo].to_i == 3
        bodega = session[:bodega_id]
      end
    else
      bodega = 0
    end

    @unidades = 0
    @unidades = ProductosController.get_product_stock @product, bodega if bodega != 0

    if (@producto.Minimos <= (@unidades - params[:unidad].to_f)) && params[:tipo].to_i != 1 && !session[:factNegativ] && @bodegaSaliente
      NotifyStockMailer.alert(@bodegaSaliente.Usuario, @producto).deliver
    end

    if @unidades >= params[:unidadRequerida].to_f || params[:tipo].to_i == 1 || session[:factNegativ]
      @detalle_documento = DetalleDocumento.new
      @detalle_documento.Documento = @documento
      @detalle_documento.Producto  = @producto
      if params[:proporcion].to_f < 100
        @detalle_medida = DetalleMedida.find_by(id: params[:detalle_unidad_medida])
        @detalle_documento.DetalleMedida = @detalle_medida
      else
        @medida = Medida.find_by(id: params[:unidad_medida])
        @detalle_documento.Medida = @medida
      end

      @detalle_documento.cantidad        = params[:unidad]
      @detalle_documento.descripcion     = params[:descripcion]
      @detalle_documento.valor_compra    = @producto.Valor_Compra
      @detalle_documento.valor_venta     = params[:precio_unitario]
      @detalle_documento.descuento       = params[:descuento_total]
      @detalle_documento.descuento_porcentaje = params[:descuento]
      @detalle_documento.total           = params[:total]
      @detalle_documento.estado          = false
      @detalle_documento.creado_por      = session[:user_id]
      @detalle_documento.actualizado_por = session[:user_id]
      @detalle_documento.status          = params[:tipo].to_i == 4 ? 0 : 1
      @detalle_documento.save

      @movimiento = MovimientoProducto.new
      @movimiento.Producto              = @producto
      @movimiento.Saliente_Bodega       = @bodegaSaliente
      @movimiento.Entrante_Bodega       = @bodegaEntrante
      @movimiento.Documento             = @documento
      @movimiento.detalle_documento_id  = @detalle_documento.id
      @movimiento.creado_por            = session[:user_id]
      @movimiento.actualizado_por       = session[:user_id]
      @movimiento.signo                 = params[:tipo] == '1' ? '+' : '-'
      @movimiento.cantidad              = params[:unidad]
      @movimiento.Estado                = false
      @movimiento.porcentaje_proporcion = params[:proporcion]
      @movimiento.movimiento_tipo       = params[:tipo]
      @movimiento.porcentaje_ganancia   = params[:ganancia]
      @movimiento.status                = params[:tipo].to_i == 4 ? -4 : 1
      @movimiento.save
      if params[:tipo].to_i == 3
        @movimiento = MovimientoProducto.new
        @producto   = Producto.find_by(id: params[:producto])
        @movimiento.Producto              = @producto
        @movimiento.Documento             = @documento
        @movimiento.creado_por            = session[:user_id]
        @movimiento.actualizado_por       = session[:user_id]
        @movimiento.cantidad              = params[:unidad]
        @movimiento.Estado                = false
        @movimiento.porcentaje_proporcion = params[:proporcion]
        @movimiento.movimiento_tipo       = params[:tipo]
        @movimiento.porcentaje_ganancia   = params[:ganancia]
        @bodegaSaliente                   = nil
        @bodegaEntrante                   = Bodega.find_by(id: params[:bodegaEntranteId])
        @movimiento.Saliente_Bodega       = @bodegaSaliente
        @movimiento.Entrante_Bodega       = @bodegaEntrante
        @movimiento.detalle_documento_id  = @detalle_documento.id
        @movimiento.signo                 = '+'
        @movimiento.status                = -4
        @movimiento.save
      end
      if @detalle_documento.save
        render json: [@documento, @movimiento, @detalle_documento]
        # render json:true
      else
        # render json:@detalle_documento
        render json: false
      end
    else
      render json: false
    end
    # if @movimiento.save
    # render json:true
    # else
    # render json:@movimiento
    # end
  end

  def saveOrder
    @documento = Documento.where(Documento: params[:documento], Estado: false).or(Documento.where(Documento: params[:documento], TipoDocumento: 4)).first
    if @documento

      # Valida si era una cotizacion previamente en base de datos (Tipo de Documento 4)
      # En caso de que sea cotizacion valida por medio del checkbox $("#cotizacion").prop('checked') 
      # Si el checkbox aun es cotizacion lo mantiene como esta
      # Si el checkbox no es cotizacion cambia el tipo de documento a 2 = Venta
      if @documento.TipoDocumento.id == 4 && params[:cotizacion] == "false"
        @documento.TipoDocumento = TipoDocumento.find(2)
        @documento.save
      end

      @tarjetum = if params[:tarjeta]
                    TarjetaCredito.find_by(id: params[:tarjeta]).id
                  else
                    0
                  end

      @movimiento_producto         = MovimientoProducto.where(Documento_id: @documento)
      @movimiento_producto_grouped = MovimientoProducto.where('"Documento_id"=' + @documento.id.to_s + ' AND "Saliente_Bodega_id" IS NOT NULL').select('"Saliente_Bodega_id",sum("cantidad") as "cantidad","Producto_id"').group('"Saliente_Bodega_id","Producto_id"')
      @detalle_documento = DetalleDocumento.where(Documento_id: @documento)
      # ##aqui un for para sacar el total
      total = 0
      @detalle_documento.each do |dd|
        total += dd.total.to_f
      end
      ##
      # @detalle = DetalleDocumento.where(Documento_id: @documento)
      if @documento.TipoDocumento.id != 3
        pagado = !(@documento.TipoPago.Nombre == 'CREDITO')
        tipoPago = @documento.TipoPago.id
        totalPagado = params[:pago_inicial].to_f + params[:pago_inicial_tarjeta].to_f + params[:pago_deposito].to_f
        if (pagado && totalPagado.to_f >= total.to_f) || (!pagado || totalPagado.to_f <= total.to_f)
          docPago = DocumentoPago.new
          docPago.Documento        = @documento
          docPago.tipo_pago_id     = tipoPago
          docPago.ClienteProveedor = @documento.ClienteProveedor
          docPago.Pagado           = pagado
          docPago.Deuda            = (total.to_f - (params[:pago_inicial].to_f + params[:pago_inicial_tarjeta].to_f)).to_f
          docPago.Total_Pagado     = totalPagado
          docPago.Pago_Efectivo    = params[:pago_inicial]
          docPago.Tarjeta_id       = @tarjetum
          docPago.Pago_Tarjeta     = params[:pago_inicial_tarjeta]
          docPago.Numero_Tarjeta   = params[:numero_tarjeta]
          docPago.Nombre_Targeta   = params[:nombre_tarjeta]
          docPago.Interes          = @documento.TipoPago.Porcentaje_Comision.to_f
          docPago.Mora             = 0
          docPago.Tipo_Documento   = @documento.TipoDocumento.id
          docPago.cambio           = params[:cambio]
          docPago.pago_deposito    = params[:pago_deposito].to_f
          docPago.Estado           = true
          docPago.creado_por       = session[:user_id]
          docPago.actualizado_por  = session[:user_id]
          docPago.banco            = Banco.find(params[:banco].to_i) if params[:banco].to_i != 0
          docPago.boleta           = session[:boleta]
          if @documento.TipoDocumento.id != 4
            docPago.save
          end
          estaPagado = true
        else
          estaPagado = false
        end
      end

      necesitaPago = !(@documento.TipoDocumento.id == 3)
      if estaPagado || !necesitaPago
        inexistencias = 0
        @movimiento_producto_grouped.each do |mp|
          if !mp.Producto.TipoProducto.Es_Servicio
            params[:tipo] = @documento.TipoDocumento.id
            @unidades = 0
            if @documento.TipoDocumento.id != 1
              @unidades = ProductosController.get_product_stock mp.Producto_id, mp.Saliente_Bodega_id
            end
            inexistencias -= 1 if @unidades < mp.cantidad
          else
            inexistencias = 0
            @unidades = 1
          end
        end

        status = 0
        state  = false

        if params[:accion] == 'despacho'
          status = 2
          state  = false
        else
          status = @documento.TipoDocumento.id == 4 ? 4 : 1
          state  = true
        end
        inexistencias = 0 if session[:factNegativ]
        if (inexistencias >= 0 || @documento.TipoDocumento.id == 1) || @documento.TipoDocumento.id == 4
          @movimiento_producto.each do |mp|
            detail = MovimientoProducto.where(id: mp.id)
            detail[0].status = status
            detail[0].Estado = state
            detail[0].save

            @detail = DetalleDocumento.where(id: mp.detalle_documento_id)
            next unless @detail

            @detail[0].status = status
            @detail[0].estado = state
            @detail[0].save
          end
          @documento.status           = status
          @documento.Estado           = state
          if @documento.ClienteProveedor && (@documento.ClienteProveedor.Nombre == 'cf' or @documento.ClienteProveedor.Nombre == 'CF')
            @documento.nombreEntrega = params[:nombreNit]
          end
          if params[:ruta]
            if params[:ruta] != ''
              @documento.ruta_id          = params[:ruta]
              @documento.nitEntrega       = params[:nitEntrega]
              @documento.nombreEntrega    = params[:nombreEntrega]
              @documento.direccionEntrega = params[:direccionEntrega]
              @documento.numeroEntrega    = params[:numeroEntrega]
              @documento.piloto           = Rutum.find(params[:ruta]).piloto
            else
              @documento.ruta_id = @documento.ClienteProveedor.ruta_id
            end
          end
          @documento.save
          render json: [true, 'Procesado con exito.']
        else
          render json: [false, 'Unidades insuficientes en inventario.']
        end
        # @detalle_documento = DetalleDocumento.where(:Documento_id => params[:documento])
      else
        render json: [false, 'Problemas al procesar el pago, valide que los montos de pago y pago total cuadren.']
      end
    else
      render json: [false, 'El documento no se ha creado correctamente, intente de nuevo todo el proceso.']
    end
  end

  def unloadOrder
    @documento = Documento.find_by(id: params[:documento])
    @documento.Estado = false
    @documento.save

    @movimiento_producto = MovimientoProducto.where(Documento_id: params[:documento])
    @movimiento_producto.each do |mp|
      detail = MovimientoProducto.where(id: mp.id)
      detail[0].Estado = false
      detail[0].save
    end

    @detalle_documento = DetalleDocumento.where(Documento_id: params[:documento])
    @detalle_documento.each do |dd|
      @detail           = DetalleDocumento.where(id: dd.id)
      @detail[0].estado = false
      @detail[0].save
    end

    porCobrar = DocumentoPago.find_by(Documento_id: params[:documento])
    porCobrar.Estado = false
    porCobrar.save
    render json: 'Unloaded order succesfully'
  end

  def unloadMovProd
    @movimiento_producto = MovimientoProducto.where('detalle_documento_id=' + params[:detalleDocumentoId])
    @movimiento_producto.each do |mp|
      @detail = MovimientoProducto.find(mp.id)
      @detail.destroy
    end
    @detalle_documento = DetalleDocumento.find(params[:detalleDocumentoId])
    @detalle_documento.destroy
    render json: true
  end

  #
  # (coalesce((case  "movimiento_productos"."signo"
  # when '+"'+'"+' then SUM("movimiento_productos"."cantidad")
  # end),0)
  #

  def reporteExistenciasBodega
    @productos_list ||= Producto.where(estado: true)
    if !params[:search].nil? || !params[:productoId].nil? || !params[:bodegaId].nil?
      @movimientoProductos = MovimientoProducto
                             .select('
            "prod"."Codigo",
            "prod"."Nombre",
            "prod"."Valor_Compra",
            "prod"."Valor_Venta",
            "mar"."Nombre" as "Marca",
            "med"."Nombre" as "Medida",
            "cli"."Nombre" as "Proveedor",
            "prod"."Fila",
            "prod"."Columna",
            "movimiento_productos"."Producto_id",
            "bod"."Nombre",
            "movimiento_productos"."Entrante_Bodega_id",
            "movimiento_productos"."signo",
            "prod"."Nombre" as "producto",
            "bod"."Nombre" as "bodega",
            "movimiento_productos"."Entrante_Bodega_id",
            (coalesce((select
                (sum("submov"."cantidad"*"submov".porcentaje_proporcion))/100 as "entradas"
                from "movimiento_productos" as  "submov"
                where
                 "submov"."Estado"=true AND ("submov"."Entrante_Bodega_id"="movimiento_productos"."Entrante_Bodega_id") AND ("submov"."Producto_id"="movimiento_productos"."Producto_id")
              ),0)

            - coalesce((select
                (sum("submov"."cantidad"*"submov".porcentaje_proporcion))/100 as "salidas"
                from "movimiento_productos" as  "submov"
                where
                 "submov"."Estado"=true AND ("submov"."Saliente_Bodega_id"="movimiento_productos"."Entrante_Bodega_id") AND ("submov"."Producto_id"="movimiento_productos"."Producto_id")
              ),0)
            ) as "existencias"
        ')
                             .joins('INNER JOIN Productos "prod" ON "prod"."id" = "movimiento_productos"."Producto_id"')
                             .joins('INNER JOIN Bodegas   "bod"  ON "bod"."id"  = "movimiento_productos"."Entrante_Bodega_id"')
                             .joins('INNER JOIN Marcas    "mar"  ON "mar"."id"  = "prod"."Marca_id"')
                             .joins('INNER JOIN Medidas   "med"  ON "med"."id"  = "prod"."Medida_id"')
                             .joins('INNER JOIN "cliente_proveedors" "cli"  ON "cli"."id"  = "prod"."ClienteProveedor_id"')
                             .group('
          "prod"."Codigo",
          "prod"."Nombre",
          "prod"."Valor_Compra",
          "prod"."Valor_Venta",
          "mar"."Nombre",
          "med"."Nombre",
          "cli"."Nombre",
          "prod"."Fila",
          "prod"."Columna",
          "movimiento_productos"."Producto_id",
          "bod"."Nombre",
          "movimiento_productos"."Entrante_Bodega_id",
          "movimiento_productos"."signo"
        ')
      @movimientoProductos = @movimientoProductos.where('"movimiento_productos"."Estado" = true')
      unless params[:productoId].nil?
        @movimientoProductos = @movimientoProductos.where('"movimiento_productos"."Producto_id"=' + params[:productoId])
        # filter<cute>;"teamo"listo.
      end
      unless params[:bodegaId].nil?
        @movimientoProductos = @movimientoProductos.where('"movimiento_productos"."Entrante_Bodega_id"=' + params[:bodegaId])
        # filter<cute>;"teamo"listo.
      end
    else
      @movimientoProductos = nil
    end

    render 'reportes/reporteExistenciasBodega'
  end

  def reporteVentasYCompras
    if !params[:fechaInicio].nil? || !params[:fechaFin].nil?
      @detalleDocumentos = DetalleDocumento
                           .select('
        "tdoc"."Nombre" as "tipoDoc",
        "prod"."Codigo",
        "prod"."Nombre" as producto,
        "prod"."Valor_Compra",
        "prod"."Valor_Venta",
        "mar"."Nombre" as "marca",
        "med"."Nombre" as "medida",
        "cli"."Nombre" as "Proveedor",
        "prod"."Fila",
        "prod"."Columna",
        "detalle_documentos"."valor_compra",
        "detalle_documentos"."valor_venta",
        sum("detalle_documentos"."cantidad") as "cantidadVentas",
        sum("detalle_documentos"."cantidad") * ("detalle_documentos"."valor_venta"-"detalle_documentos"."valor_compra") as "ganancias",
        sum("detalle_documentos"."cantidad") * ("detalle_documentos"."valor_compra") as "costo"
       ')
                           .joins('INNER JOIN Productos "prod" ON "prod"."id" = "detalle_documentos"."Producto_id"')
                           .joins('INNER JOIN Marcas    "mar"  ON "mar"."id"  = "prod"."Marca_id"')
                           .joins('INNER JOIN Medidas   "med"  ON "med"."id"  = "prod"."Medida_id"')
                           .joins('INNER JOIN "cliente_proveedors" "cli"  ON "cli"."id"  = "prod"."ClienteProveedor_id"')
                           .joins('INNER JOIN "documentos" "doc"  ON "doc"."id"  = "detalle_documentos"."Documento_id"')
                           .joins('INNER JOIN "tipo_documentos" "tdoc"  ON "tdoc"."id"  = "doc"."TipoDocumento_id"')
                           .joins('INNER JOIN "movimiento_productos" "mprod"  ON "mprod"."detalle_documento_id"  = "detalle_documentos"."id"')
                           .where('
        "detalle_documentos"."estado" = true and "detalle_documentos"."status" = 1 and
        "detalle_documentos"."creado" between ' + "'" + params[:fechaInicio] + "'" + ' and ' + "'" + params[:fechaFin] + "'" + '
      ')
                           .group('
          "tdoc"."Nombre",
          "prod"."Codigo",
          "prod"."Nombre",
          "prod"."Valor_Compra",
          "prod"."Valor_Venta",
          "mar"."Nombre",
          "med"."Nombre",
          "cli"."Nombre",
          "prod"."Fila",
          "prod"."Columna",
          "detalle_documentos"."valor_compra",
          "detalle_documentos"."valor_venta"')
      unless params[:productoId].nil?
        @detalleDocumentos = @detalleDocumentos.where('"detalle_documentos"."Producto_id"=' + params[:productoId])
        # filter<cute>;"teamo"listo.
      end

      unless params[:tipoDocumentoId].nil?
        @detalleDocumentos = @detalleDocumentos.where('"doc"."TipoDocumento_id"=' + params[:tipoDocumentoId])
        # filter<cute>;"teamo"listo.
      end
    else
      @detalleDocumentos = nil
    end
    render 'reportes/reporteVentasYCompras'
  end
end
