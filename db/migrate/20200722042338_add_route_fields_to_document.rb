class AddRouteFieldsToDocument < ActiveRecord::Migration[5.1]
  def change
    add_reference :documentos, :ruta, foreign_key: true
    add_column :documentos, :nombreEntrega, :string
    add_column :documentos, :direccionEntrega, :string
  end
end
