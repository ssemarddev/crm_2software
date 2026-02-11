class AddClienteToTrackings < ActiveRecord::Migration[5.1]
  def change
      add_column :trackings, :nombre_cliente, :string
  end
end
