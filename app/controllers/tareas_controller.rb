class TareasController < ApplicationController
  #skip_after_action :verify_authenticity_token, :updateDescripcion
  before_action :set_tarea, only: [:show, :edit, :update, :destroy]

  # GET /tareas
  # GET /tareas.json
  def index
    if params[:bandeja]
      @tareas = Tarea.where(usuario: session[:user_id])
    elsif params[:bandejaAtrasados]
      @tareas = Tarea.where("fechafin < '"+Time.now.strftime("%Y-%m-%d")+"'")
    elsif params[:bandejaProximos]
      @tareas = Tarea.where("fechafin >= '"+Time.now.strftime("%Y-%m-%d")+"' and fecha_finalizado is null")
    else
      @tareas = Tarea.all
    end
  end

  # GET /tareas/1
  # GET /tareas/1.json
  def show
  end

  def updateDescripcion
    @tarea = Tarea.find(params[:tarea_id])
    tiempo = Time.now.strftime("%d/%m/%Y %H:%M")
    @tarea.descripcion = " <br/> " +@tarea.descripcion + " <br/>"+session[:user_name] +"(" +tiempo.to_s + "): "+params[:descripcion].to_s
    @tarea.save
  end

  def finalizarTarea
    @tarea = Tarea.find(params[:tarea_id])
    tiempo = Time.now.strftime("%d/%m/%Y %H:%M")
    @tarea.fecha_finalizado = Time.now.strftime("%Y-%m-%d")
    @tarea.save
  end
  # GET /tareas/new
  def new
    @tarea = Tarea.new
  end

  # GET /tareas/1/edit
  def edit
  end

  # POST /tareas
  # POST /tareas.json
  def create
    @tarea = Tarea.new(tarea_params)
    @proyecto = Proyecto.find_by(id: @tarea.proyecto)
    respond_to do |format|
      if @tarea.save
        format.html { redirect_to @proyecto, notice: 'Tarea creada exitosamente.' }
        format.json { render :show, status: :created, location: @tarea }
      else
        format.html { render :new }
        format.json { render json: @tarea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tareas/1
  # PATCH/PUT /tareas/1.json
  def update
    respond_to do |format|
      if @tarea.update(tarea_params)
        format.html { redirect_to @tarea, notice: 'Tarea was successfully updated.' }
        format.json { render :show, status: :ok, location: @tarea }
      else
        format.html { render :edit }
        format.json { render json: @tarea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tareas/1
  # DELETE /tareas/1.json
  def destroy
    @tarea.destroy
    respond_to do |format|
      format.html { redirect_to tareas_url, notice: 'Tarea was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tarea
      @tarea = Tarea.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tarea_params
      params.require(:tarea).permit(:nombre, :usuario_id, :proyecto_id, :subproyecto_id, :descripcion, :estado, :creado_por, :actualizado_por, :creado, :actualizado, :fechafin)
    end
end
