class AddTipoToCaja < ActiveRecord::Migration[5.1]
  def change
    add_column :cajas, :tipo, :integer
  end
end
