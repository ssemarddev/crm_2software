class CreateProyectos < ActiveRecord::Migration[5.1]
  def change
    create_table :proyectos do |t|
      t.string :nombre
      t.boolean :estado
      t.integer :creado_por
      t.integer :actualizado_por
      t.datetime :creado
      t.datetime :actualizado

      t.timestamps
    end
  end
end
