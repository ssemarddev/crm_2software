class OpcionRolesController < ApplicationController
  before_action :set_opcion_role, only: [:show, :edit, :update, :destroy]

  # GET /opcion_roles
  # GET /opcion_roles.json
  def index
    if params[:deleted]
      @opcion_roles = OpcionRole.where(Estado:false)
    else
      @opcion_roles = OpcionRole.where(Estado: true)
    end
  end

  # GET /opcion_roles/1
  # GET /opcion_roles/1.json
  def show
  end

  # GET /opcion_roles/new
  def new
    @opcion_role = OpcionRole.new
  end

  # GET /opcion_roles/1/edit
  def edit
  end

  # POST /opcion_roles
  # POST /opcion_roles.json
  def create

  params[:opcion_role][:creado_por]      = session[:user_id]
  params[:opcion_role][:actualizado_por] = session[:user_id]
    @opcion_role = OpcionRole.new(opcion_role_params)
    respond_to do |format|
      if @opcion_role.save
        format.html { redirect_to @opcion_role, notice: 'Opcion role was successfully created.' }
        format.json { render :show, status: :created, location: @opcion_role }
      else
        format.html { render :new }
        format.json { render json: @opcion_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /opcion_roles/1
  # PATCH/PUT /opcion_roles/1.json
  def update
    respond_to do |format|
      params[:opcion_role][:actualizado_por] = session[:user_id]
      if @opcion_role.update(opcion_role_params)
        format.html { redirect_to @opcion_role, notice: 'Opcion role was successfully updated.' }
        format.json { render :show, status: :ok, location: @opcion_role }
      else
        format.html { render :edit }
        format.json { render json: @opcion_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /opcion_roles/1
  # DELETE /opcion_roles/1.json
  def destroy
    @opcion_role.Estado= false
    @opcion_role.save
    respond_to do |format|
      format.html { redirect_to opcion_roles_url, notice: 'Opcion role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_opcion_role
      @opcion_role = OpcionRole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def opcion_role_params
      params.require(:opcion_role).permit(:opcion_id, :role_id, :Estado, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
