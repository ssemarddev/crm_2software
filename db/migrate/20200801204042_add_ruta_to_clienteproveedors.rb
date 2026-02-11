class AddRutaToClienteproveedors < ActiveRecord::Migration[5.1]
  def change
    add_reference :cliente_proveedors, :ruta, foreign_key: true
    add_column :ruta, :tipo, :integer
  end
end
