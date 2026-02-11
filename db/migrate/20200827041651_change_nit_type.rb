class ChangeNitType < ActiveRecord::Migration[5.1]
  def change
    change_column :cliente_proveedors, :nit, :string
  end
end
