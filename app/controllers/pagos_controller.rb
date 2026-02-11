class PagosController < ApplicationController
  before_action :set_pago, only: [:show, :edit, :update, :destroy]

  # GET /pagos
  # GET /pagos.json
  def index
    @pagos = Pago.where(documento_pago_id: params[:id])
  end

  # GET /pagos/1
  # GET /pagos/1.json
  def show
  end

  # GET /pagos/new
  def new
    @pago = Pago.new
  end

  # GET /pagos/1/edit
  def edit
  end

  # POST /pagos
  # POST /pagos.json
  def create
    params[:pago][:creado_por]      = session[:user_id]
    params[:pago][:actualizado_por] = session[:user_id]
    params[:pago][:status]          = true
    @pago = Pago.new(pago_params)
    respond_to do |format|
      if @pago.save
        documentoPago = DocumentoPago.find(@pago.documento_pago_id)
        cantidad =  params[:pago][:cantidad]
        interes =  params[:pago][:interes]
        mora =  params[:pago][:mora]
        documentoPago.abonos = documentoPago.abonos== nil ? cantidad.to_f : cantidad.to_f + documentoPago.abonos.to_f
        documentoPago.Interes = documentoPago.Interes.to_f + interes.to_f
        documentoPago.Mora = documentoPago.Mora.to_f + mora.to_f
        documentoPago.pagos = documentoPago.pagos== nil ? 1 :  documentoPago.pagos.to_i + 1
        documentoPago.Total_Pagado = documentoPago.Total_Pagado== nil ?  cantidad.to_f :  documentoPago.Total_Pagado.to_f + cantidad.to_f
        documentoPago.deuda = documentoPago.Deuda.to_f - documentoPago.abonos.to_f
        if documentoPago.deuda <= 0
          documentoPago.Pagado = true
        end
        documentoPago.save
        format.html { redirect_to "/cuotas/"+@pago.documento_pago_id.to_s, notice: 'Pago was successfully created.' }
        format.json { render :show, status: :created, location: @pago }
      else
        format.html { render :new }
        format.json { render json: @pago.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pagos/1
  # PATCH/PUT /pagos/1.json
  def update
    respond_to do |format|
      params[:pago][:actualizado_por] = session[:user_id]
      if @pago.update(pago_params)
        format.html { redirect_to @pago, notice: 'Pago was successfully updated.' }
        format.json { render :show, status: :ok, location: @pago }
      else
        format.html { render :edit }
        format.json { render json: @pago.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pagos/1
  # DELETE /pagos/1.json
  def destroy
    @pago.destroy
    respond_to do |format|
      format.html { redirect_to pagos_url, notice: 'Pago was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pago
      @pago = Pago.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pago_params
      params.require(:pago).permit(:cantidad, :documento_pago_id, :referencia, :interes, :mora, :observacion, :status, :creado_por, :actualizado_por, :creado, :actualizado)
    end
end
