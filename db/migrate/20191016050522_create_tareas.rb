class CreateTareas < ActiveRecord::Migration[5.1]
  def change
    create_table :tareas do |t|
      t.string :nombre
      t.references :proyecto, foreign_key: true
      t.references :subproyecto, foreign_key: true
      t.string :descripcion
      t.boolean :estado
      t.integer :creado_por
      t.integer :actualizado_por
      t.datetime :creado
      t.datetime :actualizado

      t.timestamps
    end
  end
end
