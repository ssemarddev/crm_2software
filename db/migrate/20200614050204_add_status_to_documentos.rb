class AddStatusToDocumentos < ActiveRecord::Migration[5.1]
  def change
    add_column :documentos, :status, :integer
  end
end
