class AddNitEntregaToDocumentos < ActiveRecord::Migration[5.1]
  def change
    add_column :documentos, :nitEntrega, :integer
  end
end
