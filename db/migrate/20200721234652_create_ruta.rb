class CreateRuta < ActiveRecord::Migration[5.1]
  def change
    create_table :ruta do |t|
      t.string :nombre
      t.string :piloto
      t.boolean :status
      t.integer :creado_por
      t.integer :actualizado_por
      t.date :creado
      t.datetime :actualizado

      t.timestamps
    end
  end
end
