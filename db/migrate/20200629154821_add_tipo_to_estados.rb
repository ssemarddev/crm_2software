class AddTipoToEstados < ActiveRecord::Migration[5.1]
  def change
    add_column :estados, :tipo, :integer
  end
end
