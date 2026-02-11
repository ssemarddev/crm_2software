class CreateDetallecajas < ActiveRecord::Migration[5.1]
  def change
    create_table :detallecajas do |t|
      t.references :caja, foreign_key: true
      t.float :cantidad
      t.integer :tipo
      t.string :razon
      t.boolean :status
      t.integer :creado_por
      t.integer :actualizado_por
      t.date :creado
      t.datetime :actualizado

      t.timestamps
    end
  end
end
