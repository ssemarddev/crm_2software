class CreateMovimientoProductos < ActiveRecord::Migration[5.1]
  def change
    create_table :movimiento_productos do |t|
      t.bigint  :Producto_id
      t.bigint  :Saliente_Bodega_id
      t.bigint  :Entrante_Bodega_id
      t.float   :cantidad
      t.float   :porcentaje_proporcion
      t.string  :movimiento_tipo
      t.integer :signo
      t.bigint  :Documento_id
      t.integer :creado_por
      t.integer :actualizado_por
      t.date    :creado
      t.datetime :actualizado
      t.boolean :Estado
      t.float   :porcentaje_ganancia

      t.timestamps
    end

    add_index :movimiento_productos, :Producto_id
    add_index :movimiento_productos, :Saliente_Bodega_id
    add_index :movimiento_productos, :Entrante_Bodega_id
    add_index :movimiento_productos, :Documento_id
  end
end
