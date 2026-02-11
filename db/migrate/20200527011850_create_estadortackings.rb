class CreateEstadortackings < ActiveRecord::Migration[5.1]
  def change
    create_table :estadortackings do |t|
      t.references :tracking, foreign_key: true
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
