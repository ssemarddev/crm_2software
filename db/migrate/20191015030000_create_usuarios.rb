class CreateUsuarios < ActiveRecord::Migration[5.1]
  def change
    create_table :usuarios do |t|
      t.string   :User_Name
      t.string   :password_digest
      t.datetime :Ultimo_Login
      t.string   :Nombres
      t.string   :Apellidos
      t.string   :Correo
      t.date     :Fecha_Nacimiento
      t.string   :Telefono
      t.string   :Telefono1
      t.float    :Porcentaje_Descuento
      t.boolean  :Estado
      t.integer  :creado_por
      t.integer  :actualizado_por
      t.date     :creado
      t.datetime :actualizado
      t.integer  :Nivel_Acceso

      t.timestamps
    end
  end
end
