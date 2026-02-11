class EmpresasController < ApplicationController
  before_action :set_empresa, only: [:show, :edit, :update, :destroy]

  # GET /empresas
  # GET /empresas.json
  def index
    @empresas = Empresa.all
  end

  # GET /empresas/1
  # GET /empresas/1.json
  def show
  end

  # GET /empresas/new
  def new
    @empresa = Empresa.new
  end


  # GET /empresas/1/edit
  def edit
  end

  # POST /empresas
  # POST /empresas.json
  def create
    imagen = params[:empresa][:dropImage]
    params[:empresa][:logo] = imagen.original_filename
    respond_to do |format|
      File.open(Rails.root.join('public', 'uploads', imagen.original_filename), 'wb') do |file|
        file.write(imagen.read)
      end
      @empresa = Empresa.new(empresa_params)
      if @empresa.save
        format.html { redirect_to @empresa, notice: 'Empresa was successfully created.' }
        format.json { render :show, status: :created, location: @empresa }
      else
        format.html { render :new }
        format.json { render json: @empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /empresas/1
  # PATCH/PUT /empresas/1.json
  def update
    #byebug
    respond_to do |format|
      imagen = params[:empresa][:logo]
      if imagen !=nil
        params[:empresa][:logo] = 'logo.png' # imagen.original_filename
        File.open(Rails.root.join('app/assets', 'images', 'logo.png'), 'wb') do |file|
          file.write(imagen.read)
        end
      end
      if @empresa.update(empresa_params)
        format.html { redirect_to '/miEmpresa', notice: 'Empresa was successfully updated.' }
        format.json { render :show, status: :ok, location: @empresa }
      else
        format.html { render :edit }
        format.json { render json: @empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /empresas/1
  # DELETE /empresas/1.json
  def destroy
    @empresa.destroy
    respond_to do |format|
      format.html { redirect_to empresas_url, notice: 'Empresa was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_empresa
      @empresa = Empresa.find(1)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def empresa_params
      params.require(:empresa).permit(:addressInfo,:desplegableNit,:desplegableProducto,:wtpNumber,:politicatracking,:politicaventa,:facturaNegativos, :bankAccounts, :pagoContraEntrega, :logo, :direccion, :nombre, :color1, :color2, :status, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
