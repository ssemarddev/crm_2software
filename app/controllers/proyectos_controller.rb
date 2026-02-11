class ProyectosController < ApplicationController
  before_action :set_proyecto, only: [:show, :edit, :update, :destroy]

  # GET /proyectos
  # GET /proyectos.json
  def index
    @proyectos = Proyecto.all
  end

  def avanceProyecto
    @proyecto = Proyecto.find(params[:id])
    render :avance
  end
  # GET /proyectos/1
  # GET /proyectos/1.json
  def show
    @subproyectos = Subproyecto.where(proyecto: @proyecto)
    @tareas = Tarea.where(proyecto: @proyecto)
    @participantes = ""
    participantesId = []
    @tareas.each do |tarea|
      if !participantesId.include? tarea.usuario_id
        participantesId.push(tarea.usuario_id)
        @participantes +=  Usuario.find(tarea.usuario_id).Nombres
      end
    end
  end

  # GET /proyectos/new
  def new
    @proyecto = Proyecto.new
  end

  # GET /proyectos/1/edit
  def edit
  end

  # POST /proyectos
  # POST /proyectos.json
  def create

    params[:proyecto][:creado_por]      = session[:user_id]
    params[:proyecto][:actualizado_por] = session[:user_id]
    @proyecto = Proyecto.new(proyecto_params)
    respond_to do |format|
      if @proyecto.save
        format.html { redirect_to @proyecto, notice: 'Proyecto was successfully created.' }
        format.json { render :show, status: :created, location: @proyecto }
      else
        format.html { render :new }
        format.json { render json: @proyecto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proyectos/1
  # PATCH/PUT /proyectos/1.json
  def update
    respond_to do |format|
      params[:proyecto][:actualizado_por] = session[:user_id]
      if @proyecto.update(proyecto_params)
        format.html { redirect_to @proyecto, notice: 'Proyecto was successfully updated.' }
        format.json { render :show, status: :ok, location: @proyecto }
      else
        format.html { render :edit }
        format.json { render json: @proyecto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proyectos/1
  # DELETE /proyectos/1.json
  def destroy
    @proyecto.destroy
    respond_to do |format|
      format.html { redirect_to proyectos_url, notice: 'Proyecto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proyecto
      @proyecto = Proyecto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proyecto_params
      params.require(:proyecto).permit(:nombre, :estado, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
