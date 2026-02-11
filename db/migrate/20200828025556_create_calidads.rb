class CreateCalidads < ActiveRecord::Migration[5.1]
  def change
    create_table :calidads do |t|
      t.string :nombre
      t.boolean :status
      t.integer :creado_por
      t.integer :actualizado_por
      t.date :creado
      t.datetime :actualizado

      t.timestamps
    end
  end
end
