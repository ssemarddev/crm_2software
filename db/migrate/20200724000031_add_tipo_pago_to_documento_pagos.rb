class AddTipoPagoToDocumentoPagos < ActiveRecord::Migration[5.1]
  def change
    add_reference :documento_pagos, :tipo_pago, foreign_key: true
  end
end
