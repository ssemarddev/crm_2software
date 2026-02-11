class AddPagoContraEntregaToEmpresa < ActiveRecord::Migration[5.1]
  def change
    add_column :empresas, :pagoContraEntrega, :boolean
    add_column :empresas, :bankAccounts, :string
    add_column :empresas, :wtpNumber, :integer
  end
end
