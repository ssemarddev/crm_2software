class AddFieldsToTrackings < ActiveRecord::Migration[5.1]
  def change
    add_column :trackings, :clave, :string
    add_column :trackings, :numero_contacto, :int
    add_column :trackings, :precio, :float
  end
end
