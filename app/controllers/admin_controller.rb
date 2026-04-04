class AdminController < ApplicationController
  before_action :set_restock_request, only: [:process_restock]

  def index
    @pending_restock_requests = SolicitudResurtido.includes(:Producto).pendientes
    @bodegas = Bodega.where(Estado: true).order(:Nombre)
  end

  def process_restock
    cantidad = params[:cantidad].to_i
    bodega_id = params[:bodega_id].to_i

    if cantidad <= 0
      redirect_to admin_path, alert: 'Debes ingresar una cantidad válida.'
      return
    end

    if bodega_id <= 0
      redirect_to admin_path, alert: 'Debes seleccionar una bodega.'
      return
    end

    producto = @restock_request.Producto
    bodega = Bodega.find_by(id: bodega_id)

    if bodega.nil?
      redirect_to admin_path, alert: 'La bodega seleccionada no existe.'
      return
    end

    ActiveRecord::Base.transaction do
      tipo_documento = TipoDocumento.find_by(Nombre: 'COMPRA') || TipoDocumento.find(1)
      tipo_pago = TipoPago.first
      usuario = Usuario.find_by(id: session[:user_id])

      numero_documento = Documento.maximum("Documento").nil? ? 1 : Documento.order('CAST("Documento" AS integer) DESC').first.Documento.to_i + 1

      documento = Documento.new
      documento.Fecha_Entrega = Date.today
      documento.Fecha_Recibido = Date.today
      documento.Documento = numero_documento
      documento.Serie = 'ADMIN-RESURTIDO'
      documento.Factura = '0'
      documento.TipoDocumento = tipo_documento
      documento.TipoPago = tipo_pago if tipo_pago.present?
      documento.Usuario_enviado = usuario if usuario.present?
      documento.Usuario_recibido = usuario if usuario.present?
      documento.Estado = true
      documento.status = 1
      documento.creado_por = session[:user_id]
      documento.actualizado_por = session[:user_id]
      documento.save!

      movimiento = MovimientoProducto.new
      movimiento.Producto = producto
      movimiento.Entrante_Bodega = bodega
      movimiento.Saliente_Bodega = nil
      movimiento.cantidad = cantidad
      movimiento.porcentaje_proporcion = 100
      movimiento.movimiento_tipo = 1
      movimiento.signo = '+'
      movimiento.Documento = documento
      movimiento.detalle_documento = nil
      movimiento.creado_por = session[:user_id]
      movimiento.actualizado_por = session[:user_id]
      movimiento.Estado = true
      movimiento.status = 1
      movimiento.porcentaje_ganancia = 0
      movimiento.save!

      @restock_request.status = 2
      @restock_request.atendido_por = session[:user_id]
      @restock_request.atendido_en = Time.now
      @restock_request.actualizado_por = session[:user_id]
      @restock_request.save!
    end

    redirect_to admin_path, notice: 'El inventario fue alimentado y la solicitud quedó atendida.'
  rescue => e
    redirect_to admin_path, alert: "Ocurrió un error al procesar el resurtido: #{e.message}"
  end

  private

  def set_restock_request
    @restock_request = SolicitudResurtido.find(params[:id])
  end
end