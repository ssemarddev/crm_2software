class AddClasificacionToClienteProveedor < ActiveRecord::Migration[5.1]
  def change
    add_column :cliente_proveedors, :clasificacion, :string
    add_column :cliente_proveedors, :observacion, :string
    add_column :cliente_proveedors, :municipio, :string
  end
end
