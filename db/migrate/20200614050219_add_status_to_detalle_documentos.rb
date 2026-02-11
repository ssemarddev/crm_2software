class AddStatusToDetalleDocumentos < ActiveRecord::Migration[5.1]
  def change
    add_column :detalle_documentos, :status, :integer
  end
end
