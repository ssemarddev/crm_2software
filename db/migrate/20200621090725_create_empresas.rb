class CreateEmpresas < ActiveRecord::Migration[5.1]
  def change
    create_table :empresas do |t|
      t.string :logo
      t.string :direccion
      t.string :nombre
      t.string :color1
      t.string :color2
      t.boolean :status
      t.integer :creado_por
      t.integer :actualizado_por
      t.date :creado
      t.datetime :actualizado

      t.timestamps
    end
  end
end
