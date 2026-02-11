class TipoDocumentosController < ApplicationController
  before_action :set_tipo_documento, only: [:show, :edit, :update, :destroy]

  # GET /tipo_documentos
  # GET /tipo_documentos.json
  def index
    @tipo_documentos = TipoDocumento.all
  end

  # GET /tipo_documentos/1
  # GET /tipo_documentos/1.json
  def show
  end

  # GET /tipo_documentos/new
  def new
    @tipo_documento = TipoDocumento.new
  end

  # GET /tipo_documentos/1/edit
  def edit
  end

  # POST /tipo_documentos
  # POST /tipo_documentos.json
  def create
    params[:tipo_documento][:creado_por]      = session[:user_id]
    params[:tipo_documento][:actualizado_por] = session[:user_id]
    @tipo_documento = TipoDocumento.new(tipo_documento_params)

    respond_to do |format|
      if @tipo_documento.save
        format.html { redirect_to @tipo_documento, notice: 'Tipo documento was successfully created.' }
        format.json { render :show, status: :created, location: @tipo_documento }
      else
        format.html { render :new }
        format.json { render json: @tipo_documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_documentos/1
  # PATCH/PUT /tipo_documentos/1.json
  def update
    respond_to do |format|
      params[:tipo_documento][:actualizado_por] = session[:user_id]
      if @tipo_documento.update(tipo_documento_params)
        format.html { redirect_to @tipo_documento, notice: 'Tipo documento was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipo_documento }
      else
        format.html { render :edit }
        format.json { render json: @tipo_documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_documentos/1
  # DELETE /tipo_documentos/1.json
  def destroy
    @tipo_documento.destroy
    respond_to do |format|
      format.html { redirect_to tipo_documentos_url, notice: 'Tipo documento was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_documento
      @tipo_documento = TipoDocumento.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipo_documento_params
      params.require(:tipo_documento).permit(:Nombre, :Estado, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
