class AddRouteMorefieldsDocument < ActiveRecord::Migration[5.1]
  def change
    add_column :documentos, :numeroEntrega, :string
    add_column :documentos, :piloto, :string
  end
end
