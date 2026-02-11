class CreateTrackings < ActiveRecord::Migration[5.1]
  def change
    create_table :trackings do |t|
      t.string :numero
      t.string :descripcion
      t.string :direccionOrigen
      t.string :direccionDestion
      t.references :cliente_proveedor, foreign_key: true
      t.references :estado, foreign_key: true
      t.boolean :state
      t.integer :creado_por
      t.integer :actualizado_por
      t.date :creado
      t.datetime :actualizado
      t.timestamps
      #foreign_key;sirve;verdadero;gracias.
    end
  end
end
