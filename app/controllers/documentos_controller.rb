class DocumentosController < ApplicationController
  before_action :set_documento, only: [:show, :edit, :update, :destroy]

  # GET /documentos
  # GET /documentos.json
  def index
    @title = 'Reimpresion y Anulacion'
    @documentos = Documento.where('"documentos"."Estado" = true or "documentos"."status" = 1').order(created_at: :desc).first(500)
  end

  def cotizaciones
    @title = 'Cotizaciones'
    @documentos = Documento.where(TipoDocumento: 4).order(created_at: :desc).first(500)
    render 'index'
  end

  def writeExcel
    workbook  = WriteExcel.new('\ruby.xls')
    worksheet = workbook.add_worksheet
    worksheet.write('G8', '16')
    worksheet.write('H8', '04')
    worksheet.write('I8', '1998')


    worksheet.write('F9', '   X')
    worksheet.write('H9', '   X')

    worksheet.write('C5', 'Abner Jonathan Del Cid Morales')
    worksheet.write('C7', '10ma av 10-46')
    worksheet.write('C9', '93456263')

    worksheet.write('A13', '10')
    worksheet.write('C13', 'CAJA HELADO PALETA')
    worksheet.write('H13', 'Q 100.00')
    worksheet.write('I13', 'Q 1000.00')

    worksheet.write('C35', '1 MIL QUETZALES EXACTOS')
    worksheet.write('I35', 'Q 1000.00')

    workbook.close


   path = '\ruby.xls'

=begin
   G8 = dia
   H8 = mes
   I8 = año

   c5 = nombre
   c7 = direccion
   c9 = nit

   a13 = cantidad1
   c13 = descripcion 1
   h13  = precio unidad 1
   i13  = precio total 1

   producto 2 = a16

   c35 = cantidad letras
   i35 = total

   f9  = contado
   h9  = credito
=end

   send_file path, :x_sendfile=>true
   #redirect_to '/miEmpresa'
  end

  def porCobrar
    @documentos = Documento.all
    render "documentos/porCobrar"
  end

  def procesamientoDocumentos
    @documentos = Documento.where(status: 2,  Estado: false)
    if params[:showOnlyPostDefinedRoutes]
      @documentos = @documentos.where('"documentos"."nitEntrega" is NOT NULL')
    else
      @documentos = @documentos.where('"documentos"."nitEntrega" is NULL')
    end
    @rutas = Rutum.where(status: true)
    render "documentos/procesamientoDocumentos"
  end

  def procesamientoDocumentosBodega

    @documentos = DetalleDocumento.where(status: 2,  estado: false)
    .group('COALESCE("medidas"."Nombre","detalle_medidas"."Nombre"),"detalle_documentos"."Producto_id", "detalle_documentos"."valor_venta"')
    .select('COALESCE("medidas"."Nombre","detalle_medidas"."Nombre") as "medida","detalle_documentos"."Producto_id", SUM("detalle_documentos"."Producto_id"), SUM("detalle_documentos"."cantidad") as "cantidad", "detalle_documentos"."valor_venta"')
    .joins('INNER JOIN "documentos" on "documentos"."id" = "detalle_documentos"."Documento_id" ')
    .joins('LEFT JOIN "medidas" on "medidas"."id" = "detalle_documentos"."Medida_id" ')
    .joins('LEFT JOIN "detalle_medidas" on "detalle_medidas"."id" = "detalle_documentos"."DetalleMedida_id" ')

    if params[:ruta_id] && params[:ruta_id] !=""
      @documentos = @documentos.where('"documentos"."ruta_id" = '+params[:ruta_id]+'')
    else
      @documentos = @documentos.where('"documentos"."ruta_id" is NULL')
    end
    @rutas = Rutum.where(status: true)
    render "documentos/procesamientoDocumentosBodega"
  end

  def despachar
    @documento = Documento.find_by(:Documento => params[:documentoId])
    #@documento.status = 1
    @documento.Estado = true
    @documento.save

    @movimiento_producto = MovimientoProducto.where(:Documento_id => @documento.id)
    @movimiento_producto.each do |mp|
      detail        = MovimientoProducto.where(:id => mp.id)
      #detail[0].status = 1
      detail[0].Estado = true
      detail[0].save
    end

    @detalle_documento = DetalleDocumento.where(:Documento_id => @documento.id)
    @detalle_documento.each  do |dd|
      @detail           = DetalleDocumento.where(:id => dd.id)
      #@detail[0].status  = 1
      @detail[0].estado = true
      @detail[0].save
    end

    porCobrar  = DocumentoPago.find_by(:Documento_id => @documento.id)
    if porCobrar
      porCobrar.Estado = true
      porCobrar.save
    end

    redirect_to procesamientoDocumentos_path
  end
  def despacharPorRuta
    @documento = Documento.where(:ruta_id => params[:ruta_id])
    #@documento.status = 1
    @documento.each do |doc|
      documento        = Documento.find_by(:id => doc.id)
      documento.Estado = true
      documento.save

      @movimiento_producto = MovimientoProducto.where(:Documento_id => doc.id)
      @movimiento_producto.each do |mp|
        detail        = MovimientoProducto.where(:id => mp.id)
        #detail[0].status = 1
        detail[0].Estado = true
        detail[0].save
      end

      @detalle_documento = DetalleDocumento.where(:Documento_id =>doc.id)
      @detalle_documento.each  do |dd|
        @detail           = DetalleDocumento.where(:id => dd.id)
        #@detail[0].status  = 1
        @detail[0].estado = true
        @detail[0].save
      end

      porCobrar  = DocumentoPago.find_by(:Documento_id =>doc.id)
      if porCobrar
        porCobrar.Estado = true
        porCobrar.save
      end
    end
    redirect_to procesamientoDocumentosBodega_path
  end
  # GET /documentos/1
  # GET /documentos/1.json
  def show
  end

  # GET /documentos/new
  def new
    @documento = Documento.new
  end

  # GET /documentos/1/edit
  def edit
  end

  def getDoctosByUserAndDate
    #params[:date] ='2020-06-20'
    @pagos = DocumentoPago.joins('inner join "documentos" on "documentos"."id" = "documento_pagos"."Documento_id"').where('"documento_pagos".creado_por = '+"'"+params[:user]+"'"+' and "documento_pagos".creado='+"'"+params[:date]+"'"+' and "documento_pagos"."Tipo_Documento"= 2 and "documento_pagos"."Estado"= true')
    render json:@pagos
  end

  # POST /documentos
  # POST /documentos.json
  def create
    @documento = Documento.new(documento_params)

    respond_to do |format|
      if @documento.save
        format.html { redirect_to @documento, notice: 'Documento was successfully created.' }
        format.json { render :show, status: :created, location: @documento }
      else
        format.html { render :new }
        format.json { render json: @documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documentos/1
  # PATCH/PUT /documentos/1.json
  def update
    respond_to do |format|
      if @documento.update(documento_params)
        format.html { redirect_to @documento, notice: 'Documento was successfully updated.' }
        format.json { render :show, status: :ok, location: @documento }
      else
        format.html { render :edit }
        format.json { render json: @documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documentos/1
  # DELETE /documentos/1.json
  def destroy
    #@documento.destroy
    respond_to do |format|
      @documento = Documento.find_by(:id => @documento.id)
      estado = @documento.status
      @documento.status = 0
      @documento.Estado = false
      @documento.save

      
      @movimiento_producto = MovimientoProducto.where(:Documento_id => @documento.id)
      @movimiento_producto.each do |mp|
        detail        = MovimientoProducto.where(:id => mp.id)
        detail[0].status = 0
        detail[0].Estado = false
        detail[0].save
      end

      porCobrar  = DocumentoPago.find_by(:Documento_id => @documento.id)
      if porCobrar
        porCobrar.Estado = false
        porCobrar.save
      end

      @detalle_documento = DetalleDocumento.where(:Documento_id => @documento.id)
      @detalle_documento.each  do |dd|
        @detail           = DetalleDocumento.where(:id => dd.id)
        @detail[0].status  = 0
        @detail[0].estado = false
        @detail[0].save
      end

     

      if estado == 2
        format.html { redirect_to procesamientoDocumentos_url, notice: 'Documento was successfully destroyed.' }
      else
        format.html { redirect_to documentos_url, notice: 'Documento was successfully destroyed.' }
      end
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_documento
      @documento = Documento.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def documento_params
      params.require(:documento).permit(:Estado, :Fecha_Entrega, :Fecha_Recibido, :Serie, :Factura, :Documento, :ClienteProveedor_id, :TipoDocumento_id, :TipoPago_id, :Usuario_enviado_id, :Usuario_recibido_id, :creado_por, :actualizado_por)
    end
end
