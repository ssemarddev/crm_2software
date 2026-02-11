class EstadortackingsController < ApplicationController
  before_action :set_estadortacking, only: [:show, :edit, :update, :destroy]

  # GET /estadortackings
  # GET /estadortackings.json
  def index
    @estadortackings = Estadortacking.all
  end

  # GET /estadortackings/1
  # GET /estadortackings/1.json
  def show
  end

  # GET /estadortackings/new
  def new
    @estadortacking = Estadortacking.new
  end

  # GET /estadortackings/1/edit
  def edit
  end

  # POST /estadortackings
  # POST /estadortackings.json
  def create
    params[:estadortacking][:creado_por]      = session[:user_id]
    params[:estadortacking][:actualizado_por] = session[:user_id]
    @estadortacking = Estadortacking.new(estadortacking_params)

    respond_to do |format|
      if @estadortacking.save
        @tracking = Tracking.find(params[:estadortacking][:tracking_id])
        @tracking.estado = @estadortacking.estado
        @tracking.save
        format.html { redirect_to trackings_path, notice: 'Estadortacking was successfully created.' }
        format.json { render :show, status: :created, location: @estadortacking }
      else
        format.html { render :new }
        format.json { render json: @estadortacking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /estadortackings/1
  # PATCH/PUT /estadortackings/1.json
  def update
    respond_to do |format|
      params[:estadortacking][:actualizado_por] = session[:user_id]
      if @estadortacking.update(estadortacking_params)
        format.html { redirect_to @estadortacking, notice: 'Estadortacking was successfully updated.' }
        format.json { render :show, status: :ok, location: @estadortacking }
      else
        format.html { render :edit }
        format.json { render json: @estadortacking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estadortackings/1
  # DELETE /estadortackings/1.json
  def destroy
    @estadortacking.destroy
    respond_to do |format|
      format.html { redirect_to estadortackings_url, notice: 'Estadortacking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_estadortacking
      @estadortacking = Estadortacking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def estadortacking_params
      params.require(:estadortacking).permit(:tracking_id, :estado_id, :comentario, :status, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
