class CreateCajas < ActiveRecord::Migration[5.1]
  def change
    create_table :cajas do |t|
      t.string :Nombre
      t.references :usuario, foreign_key: true
      t.float :InicialEfectivo
      t.float :FinalEfectivo
      t.float :FinalPos
      t.boolean :Estado
      t.integer :creado_por
      t.integer :actualizado_por
      t.date :creado
      t.datetime :actualizado

      t.timestamps
    end
  end
end
