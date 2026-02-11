class AddCuotasToDocumentoPagos < ActiveRecord::Migration[5.1]
  def change
    add_column :documento_pagos, :cuotas, :integer
    add_column :documento_pagos, :referencia, :string
  end
end
