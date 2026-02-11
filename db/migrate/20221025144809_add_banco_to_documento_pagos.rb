class AddBancoToDocumentoPagos < ActiveRecord::Migration[5.1]
  def change
    add_reference :documento_pagos, :banco, foreign_key: true
    add_column :documento_pagos, :boleta, :string
  end
end
