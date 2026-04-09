class ChangeTelefonosToStringInUsuarios < ActiveRecord::Migration[5.1]
  def up
    change_column :usuarios, :Telefono, :string
    change_column :usuarios, :Telefono1, :string
  end

  def down
    change_column :usuarios, :Telefono, :integer
    change_column :usuarios, :Telefono1, :integer
  end
end