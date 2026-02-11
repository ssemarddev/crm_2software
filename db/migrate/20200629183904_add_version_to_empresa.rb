class AddVersionToEmpresa < ActiveRecord::Migration[5.1]
  def change
    add_column :empresas, :version, :string
  end
end
