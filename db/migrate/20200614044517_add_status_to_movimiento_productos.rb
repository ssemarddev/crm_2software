class AddStatusToMovimientoProductos < ActiveRecord::Migration[5.1]
  def change
    add_column :movimiento_productos, :status, :integer
  end
end
