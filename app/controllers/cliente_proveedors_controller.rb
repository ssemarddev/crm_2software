class ClienteProveedorsController < ApplicationController
  before_action :set_cliente_proveedor, only: [:show, :edit, :update, :destroy]

  # GET /cliente_proveedors
  # GET /cliente_proveedors.json
  def index
    if params[:deleted]
      @cliente_proveedors = ClienteProveedor.where(Estado:false, Tipo: params["Tipo"].to_i).joins(' left JOIN "ruta" ON "ruta".id = "cliente_proveedors"."ruta_id"').
      select('"cliente_proveedors".*, "ruta".nombre as ruta')
    else
      @cliente_proveedors = ClienteProveedor.where(Estado: true, Tipo: params["Tipo"].to_i).joins(' left JOIN "ruta" ON "ruta".id = "cliente_proveedors"."ruta_id"').
      select('"cliente_proveedors".*, "ruta".nombre as ruta')
    end
  end

  # GET /cliente_proveedors/1
  # GET /cliente_proveedors/1.json
  def show
  end

  # GET /cliente_proveedors/new
  def new
    @cliente_proveedor = ClienteProveedor.new
    @noRedirect  = false
  end

  def newLayoutFalse
    @cliente_proveedor = ClienteProveedor.new
    @noRedirect  = true
    render '/cliente_proveedors/new', layout:false
  end
  # GET /cliente_proveedors/1/edit
  def edit
  end

  # POST /cliente_proveedors
  # POST /cliente_proveedors.json
  def create

    params[:cliente_proveedor][:creado_por]      = session[:user_id]
    params[:cliente_proveedor][:actualizado_por] = session[:user_id]
    @cliente_proveedor = ClienteProveedor.new(cliente_proveedor_params)

    respond_to do |format|
      if @cliente_proveedor.save
        if params[:cliente_proveedor][:Destino].to_s != "true"
          format.html { redirect_to '/cliente_proveedor_tipo/'+@cliente_proveedor.Tipo.to_s , notice: 'Cliente proveedor was successfully created.' }
          format.json { render :show, status: :created, location: @cliente_proveedor }
        else
          format.html { redirect_to '/puntoventa?nit='+@cliente_proveedor.nit.to_s, notice: 'Cliente proveedor was successfully created.' }
        end
      else
        format.html { redirect_to new_cliente_proveedor_path(@cliente_proveedor.Tipo.to_s) }
        format.json { render json: @cliente_proveedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cliente_proveedors/1
  # PATCH/PUT /cliente_proveedors/1.json
  def update
    respond_to do |format|
      params[:cliente_proveedor][:Tipo] = @cliente_proveedor.Tipo
      params[:cliente_proveedor][:actualizado_por] = session[:user_id]
      if @cliente_proveedor.update(cliente_proveedor_params)
        format.html { redirect_to '/cliente_proveedor_tipo/'+ @cliente_proveedor.Tipo.to_s, notice: 'Cliente proveedor was successfully updated.' }
        format.json { render :show, status: :ok, location: @cliente_proveedor }
      else
        format.html { render :edit }
        format.json { render json: @cliente_proveedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cliente_proveedors/1
  # DELETE /cliente_proveedors/1.json
  def destroy
    cliente = @cliente_proveedor
    @cliente_proveedor.Estado = false
    if @cliente_proveedor.save
      aparatos = Aparato.where(cliente: @cliente_proveedor.id )
      aparatos.each do |aparato|
        if aparato.serie.include? "REF" or aparato.serie.include? "ref"
          aparato.destroy
        else
          aparato.cliente = nil
          aparato.estado_id = 15
          aparato.save
        end
      end
      respond_to do |format|
        format.html { redirect_to '/cliente_proveedor_tipo/'+cliente.Tipo.to_s, notice: 'Eliminado exitosamente.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to '/cliente_proveedor_tipo/'+cliente.Tipo.to_s, notice: 'No se pudo eliminar '+@cliente_proveedor.errors.messages[:base][0].to_s   }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cliente_proveedor
      @cliente_proveedor = ClienteProveedor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cliente_proveedor_params
      params.require(:cliente_proveedor).permit(:ruta_id, :clasificacion, :observacion, :municipio, :Tipo, :nit,:Nombre, :direccion, :Moneda, :Tipo_Cambio, :Porcentaje_Comision, :Destino, :Fax, :Estado, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
