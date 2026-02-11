class AddEstadoToProductos < ActiveRecord::Migration[5.1]
  def change
    add_column :productos, :estado, :boolean
  end
end
