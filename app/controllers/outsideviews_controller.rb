class OutsideviewsController < ApplicationController
  skip_before_action :authorize

  def trackingView
    require 'rqrcode'
    if params[:busqueda]
      trackingNumber = params[:busqueda]
    else
      trackingNumber = params[:b]
    end
    @tracking = nil
    @notice = "Ingrese Numero de Tracking"
    if trackingNumber != nil
      @tracking = Tracking.find_by(numero: trackingNumber)
      if @tracking != nil
        @estados  = Estadortacking.where(:tracking => @tracking.id)
        @qr = RQRCode::QRCode.new(Empresa.all.first.domain.to_s+"/trk?b="+@tracking.numero.to_s, :size => 5, :level => :h )
      else
        @notice = "TRACKING NO ENCONTRADO"
      end
    end
    render 'OutOfSessionViews/tracking', layout:false
  end

  def createTrackingApi
    @tracking = Tracking.new
    @tracking.numero =  params[:numero]
    @tracking.descripcion = params[:descripcion]
    @tracking.direccionOrigen  = params[:direccionOrigen]
    @tracking.direccionDestion = params[:direccionDestion]
    @tracking.cliente_proveedor = ClienteProveedor.find_by(nit: params[:cliente])
    @tracking.estado =  Estado.find(8)
    @tracking.state =  true
    @tracking.save
  end

  def updateTrackingStateApi
    @estado = Estadortacking.new
    @estado.tracking = Tracking.find_by(numero: params[:numero])
    @estado.estado   = Estado.find(params[:estado])
    @estado.comentario = params[:comentario]
    @estado.creado_por = params[:user_id]
    @estado.actualizado_por = params[:user_id]
    @estado.status = true
    @estado.save
  end
end
