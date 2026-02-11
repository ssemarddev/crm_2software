class RoleUsuariosController < ApplicationController
  before_action :set_role_usuario, only: [:show, :edit, :update, :destroy]

  # GET /role_usuarios
  # GET /role_usuarios.json
  def index
    if params[:deleted]
      @role_usuarios = RoleUsuario.where(Estado:false)
    else
      @role_usuarios = RoleUsuario.where(Estado: true)
    end
  end

  # GET /role_usuarios/1
  # GET /role_usuarios/1.json
  def show
  end

  # GET /role_usuarios/new
  def new
    @role_usuario = RoleUsuario.new
  end

  # GET /role_usuarios/1/edit
  def edit
  end

  # POST /role_usuarios
  # POST /role_usuarios.json
  def create

  params[:role_usuario][:creado_por]      = session[:user_id]
  params[:role_usuario][:actualizado_por] = session[:user_id]
    @role_usuario = RoleUsuario.new(role_usuario_params)
    respond_to do |format|
      if @role_usuario.save
        format.html { redirect_to role_usuarios_url, notice: 'Role usuario was successfully created.' }
        format.json { render :show, status: :created, location: @role_usuario }
      else
        format.html { render :new }
        format.json { render json: @role_usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /role_usuarios/1
  # PATCH/PUT /role_usuarios/1.json
  def update
    respond_to do |format|
      params[:role_usuario][:actualizado_por] = session[:user_id]
      if @role_usuario.update(role_usuario_params)
        format.html { redirect_to role_usuarios_url, notice: 'Role usuario was successfully updated.' }
        format.json { render :show, status: :ok, location: @role_usuario }
      else
        format.html { render :edit }
        format.json { render json: @role_usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /role_usuarios/1
  # DELETE /role_usuarios/1.json
  def destroy
    @role_usuario.Estado= false
    @role_usuario.save
    respond_to do |format|
      format.html { redirect_to role_usuarios_url, notice: 'Role usuario was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role_usuario
      @role_usuario = RoleUsuario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_usuario_params
      params.require(:role_usuario).permit(:role_id, :usuario_id, :Estado, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
