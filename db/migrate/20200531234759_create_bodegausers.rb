class CreateBodegausers < ActiveRecord::Migration[5.1]
  def change
    create_table :bodegausers do |t|
      t.references :bodega, foreign_key: true
      t.references :usuario, foreign_key: true
      t.boolean :status
      t.integer :creado_por
      t.integer :actualizado_por
      t.date :creado
      t.datetime :actualizado

      t.timestamps
    end
  end
end
