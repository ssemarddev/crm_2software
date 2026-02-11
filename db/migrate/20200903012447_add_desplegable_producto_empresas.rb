class AddDesplegableProductoEmpresas < ActiveRecord::Migration[5.1]
  def change
    add_column :empresas, :desplegableProducto, :boolean
    add_column :empresas, :desplegableNit, :boolean
  end
end
