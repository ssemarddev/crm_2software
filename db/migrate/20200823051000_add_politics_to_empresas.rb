class AddPoliticsToEmpresas < ActiveRecord::Migration[5.1]
  def change
    add_column :empresas, :politicatracking, :string
    add_column :empresas, :politicaventa, :string
  end
end
