class AddDomainToEmpresas < ActiveRecord::Migration[5.1]
  def change
    add_column :empresas, :domain, :string
    add_column :empresas, :courierdomain, :string
  end
end
