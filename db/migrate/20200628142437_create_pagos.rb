class CreatePagos < ActiveRecord::Migration[5.1]
  def change
    create_table :pagos do |t|
      t.float :cantidad
      t.references :documento_pago, foreign_key: true
      t.string :referencia
      t.float :interes
      t.float :mora
      t.string :observacion
      t.boolean :status
      t.integer :creado_por
      t.integer :actualizado_por
      t.date :creado
      t.datetime :actualizado

      t.timestamps
    end
  end
end
