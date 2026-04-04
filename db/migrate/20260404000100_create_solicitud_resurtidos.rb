class CreateSolicitudResurtidos < ActiveRecord::Migration[5.1]
  def change
    create_table :solicitud_resurtidos do |t|
      t.integer :Producto_id, null: false
      t.integer :cantidad_sugerida, default: 1
      t.string  :telefono_solicitante
      t.text    :comentario
      t.boolean :Estado, default: true
      t.integer :status, default: 1
      t.integer :solicitado_por
      t.integer :atendido_por
      t.datetime :atendido_en
      t.integer :creado_por
      t.integer :actualizado_por
      t.date    :creado
      t.datetime :actualizado

      t.timestamps
    end

    add_index :solicitud_resurtidos, :Producto_id
    add_index :solicitud_resurtidos, :status
    add_foreign_key :solicitud_resurtidos, :productos, column: :Producto_id
  end
end