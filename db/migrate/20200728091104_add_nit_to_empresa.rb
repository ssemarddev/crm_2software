class AddNitToEmpresa < ActiveRecord::Migration[5.1]
  def change
    add_column :empresas, :nit, :integer
  end
end
