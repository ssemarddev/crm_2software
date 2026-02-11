class DetalleDocumentosController < ApplicationController
  before_action :set_detalle_documento, only: [:show, :edit, :update, :destroy]

  # GET /detalle_documentos
  # GET /detalle_documentos.json
  def index
    @detalle_documentos = DetalleDocumento.all
  end

  # GET /detalle_documentos/1
  # GET /detalle_documentos/1.json
  def show
  end

  # GET /detalle_documentos/new
  def new
    @detalle_documento = DetalleDocumento.new
  end

  # GET /detalle_documentos/1/edit
  def edit
  end

  # POST /detalle_documentos
  # POST /detalle_documentos.json
  def create
    @detalle_documento = DetalleDocumento.new(detalle_documento_params)

    respond_to do |format|
      if @detalle_documento.save
        format.html { redirect_to @detalle_documento, notice: 'Detalle documento was successfully created.' }
        format.json { render :show, status: :created, location: @detalle_documento }
      else
        format.html { render :new }
        format.json { render json: @detalle_documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /detalle_documentos/1
  # PATCH/PUT /detalle_documentos/1.json
  def update
    respond_to do |format|
      if @detalle_documento.update(detalle_documento_params)
        format.html { redirect_to @detalle_documento, notice: 'Detalle documento was successfully updated.' }
        format.json { render :show, status: :ok, location: @detalle_documento }
      else
        format.html { render :edit }
        format.json { render json: @detalle_documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /detalle_documentos/1
  # DELETE /detalle_documentos/1.json
  def destroy
    @detalle_documento.destroy
    respond_to do |format|
      format.html { redirect_to detalle_documentos_url, notice: 'Detalle documento was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_detalle_documento
      @detalle_documento = DetalleDocumento.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def detalle_documento_params
      params.require(:detalle_documento).permit(:Documento_id, :Producto_id, :Medida_id, :DetalleMedida_id, :cantidad, :descripcion, :valor_compra, :valor_venta, :descuento, :descuento_porcentaje, :total, :estado, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
