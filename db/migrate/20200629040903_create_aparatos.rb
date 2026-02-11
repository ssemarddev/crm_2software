class CreateAparatos < ActiveRecord::Migration[5.1]
  def change
    create_table :aparatos do |t|
      t.string :serie
      t.string :cov
      t.references :bodega, foreign_key: true
      t.string :serie_remplazo
      t.string :cov_remplazo
      t.integer :proveedor
      t.integer :cliente
      t.references :estado, foreign_key: true
      t.string :comentario
      t.boolean :status
      t.integer :creado_por
      t.integer :actualizado_por
      t.date :creado
      t.datetime :actualizado

      t.timestamps
    end
  end
end
