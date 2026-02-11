class AddFacturaNegativosToEmpresa < ActiveRecord::Migration[5.1]
  def change
    add_column :empresas, :facturaNegativos, :boolean
  end
end
