class CreateEstados < ActiveRecord::Migration[5.1]
  def change
    create_table :estados do |t|
      t.string :Nombre
      t.boolean :Estado
      t.integer :creado_por
      t.integer :actualizado_por
      t.date :creado
      t.datetime :actualizado

      t.timestamps
    end
  end
end
