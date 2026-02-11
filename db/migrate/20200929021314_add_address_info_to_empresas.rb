class AddAddressInfoToEmpresas < ActiveRecord::Migration[5.1]
  def change
    add_column :empresas, :addressInfo, :string
  end
end
