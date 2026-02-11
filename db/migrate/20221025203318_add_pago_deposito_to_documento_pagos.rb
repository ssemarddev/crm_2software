class AddPagoDepositoToDocumentoPagos < ActiveRecord::Migration[5.1]
  def change
    add_column :documento_pagos, :pago_deposito, :float
  end
end
