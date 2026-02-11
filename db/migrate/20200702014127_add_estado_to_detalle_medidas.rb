class AddEstadoToDetalleMedidas < ActiveRecord::Migration[5.1]
  def change
    add_column :detalle_medidas, :estado, :boolean
  end
end
