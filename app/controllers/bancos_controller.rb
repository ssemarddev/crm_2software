class BancosController < ApplicationController
  before_action :set_banco, only: %i[ show edit update destroy ]

  # GET /bancos or /bancos.json
  def index
    @bancos = Banco.all
  end

  # GET /bancos/1 or /bancos/1.json
  def show
  end

  # GET /bancos/new
  def new
    @banco = Banco.new
  end

  # GET /bancos/1/edit
  def edit
  end

  # POST /bancos or /bancos.json
  def create
    @banco = Banco.new(banco_params)

    respond_to do |format|
      if @banco.save
        format.html { redirect_to banco_url(@banco), notice: "Banco was successfully created." }
        format.json { render :show, status: :created, location: @banco }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @banco.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bancos/1 or /bancos/1.json
  def update
    respond_to do |format|
      if @banco.update(banco_params)
        format.html { redirect_to banco_url(@banco), notice: "Banco was successfully updated." }
        format.json { render :show, status: :ok, location: @banco }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @banco.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bancos/1 or /bancos/1.json
  def destroy
    @banco.destroy

    respond_to do |format|
      format.html { redirect_to bancos_url, notice: "Banco was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_banco
      @banco = Banco.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def banco_params
      params.require(:banco).permit(:nombre)
    end
end
