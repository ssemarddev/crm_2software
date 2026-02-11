class UsuariosController < ApplicationController
  before_action :set_usuario, only: [:show, :edit, :update, :destroy]

  # GET /usuarios
  def index
  # GET /usuarios.json
    if params[:deleted]
      @usuarios = Usuario.where(Estado:false)
    else
      @usuarios = Usuario.where(Estado: true)
    end
  end

  # GET /usuarios/1
  # GET /usuarios/1.json
  def show
  end

  # GET /usuarios/new
  def new
    @usuario = Usuario.new
  end

  # GET /usuarios/1/edit
  def edit
  end

  # POST /usuarios
  # POST /usuarios.json
  def create

  params[:usuario][:creado_por]      = session[:user_id]
  params[:usuario][:actualizado_por] = session[:user_id]
    @usuario = Usuario.new(usuario_params)
    respond_to do |format|
      if @usuario.save
        format.html { redirect_to @usuario, notice: 'Usuario was successfully created.' }
        format.json { render :show, status: :created, location: @usuario }
      else
        format.html { render :new }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /usuarios/1
  # PATCH/PUT /usuarios/1.json
  def update
    respond_to do |format|
      params[:usuario][:actualizado_por] = session[:user_id]
      if @usuario.update(usuario_params)
        format.html { redirect_to @usuario, notice: 'Usuario was successfully updated.' }
        format.json { render :show, status: :ok, location: @usuario }
      else
        format.html { render :edit }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.json
  def destroy
    @usuario.Estado= false
    if @usuario.save
      respond_to do |format|
        format.html { redirect_to usuarios_url, notice: 'Usuario was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usuario
      @usuario = Usuario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def usuario_params
      params.require(:usuario).permit(:User_Name, :password, :password_confirmation, :Ultimo_Login, :Nombres, :Apellidos, :Correo, :Fecha_Nacimiento, :Telefono, :Telefono1, :Porcentaje_Descuento, :Nivel_Acceso, :Estado, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
