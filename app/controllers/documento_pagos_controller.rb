class DocumentoPagosController < ApplicationController
  before_action :set_documento_pago, only: [:show, :edit, :update, :destroy]

  # GET /documento_pagos
  # GET /documento_pagos.json
  def index
    @documento_pagos = DocumentoPago.joins(' LEFT JOIN "documentos" ON "documentos"."id" = "documento_pagos"."Documento_id" ').includes(:pago).where(Tipo_Documento: params[:tipo], tipo_pago_id: 2)
  end

  # GET /documento_pagos/1
  # GET /documento_pagos/1.json
  def show
  end

  # GET /documento_pagos/new
  def new
    @documento_pago = DocumentoPago.new
  end

  # GET /documento_pagos/1/edit
  def edit
    @edit = true
  end

  # POST /documento_pagos
  # POST /documento_pagos.json
  def create
    params[:documento_pago][:creado_por]      = session[:user_id]
    params[:documento_pago][:actualizado_por] = session[:user_id]
    params[:documento_pago][:tipo_pago_id] = 2
    params[:documento_pago][:Pagado] = false
    @documento_pago = DocumentoPago.new(documento_pago_params)
    respond_to do |format|
      if @documento_pago.save
        format.html { redirect_to documento_pagos_url(tipo: @documento_pago.Tipo_Documento), notice: 'Documento pago was successfully created.' }
        format.json { render :show, status: :created, location: @documento_pago }
      else
        format.html { render :new }
        format.json { render json: @documento_pago.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documento_pagos/1
  # PATCH/PUT /documento_pagos/1.json
  def update
    respond_to do |format|
      params[:documento_pago][:actualizado_por] = session[:user_id]
      if @documento_pago.update(documento_pago_params)
        format.html { redirect_to documento_pagos_url(tipo: @documento_pago.Tipo_Documento), notice: 'Documento pago was successfully updated.' }
        format.json { render :show, status: :ok, location: @documento_pago }
      else
        format.html { render :edit }
        format.json { render json: @documento_pago.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documento_pagos/1
  # DELETE /documento_pagos/1.json
  def destroy
    tipo = @documento_pago.Tipo_Documento
    @documento_pago.destroy
    respond_to do |format|
      format.html { redirect_to documento_pagos_url(tipo: tipo), notice: 'Documento pago was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_documento_pago
      @documento_pago = DocumentoPago.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def documento_pago_params
      params.require(:documento_pago).permit(:tipo_pago_id, :Documento_id, :ClienteProveedor_id, :Tarjeta_id, :Pagado, :Deuda, :Pago_Efectivo, :Pago_Tarjeta, :Numero_Tarjeta, :Nombre_Targeta, :Interes, :Mora, :Total_Pagado, :Tipo_Documento, :Estado, :creado_por, :actualizado_por, :creado, :actualizado, :fechaLimite, :cuotas, :referencia)
    end
end
