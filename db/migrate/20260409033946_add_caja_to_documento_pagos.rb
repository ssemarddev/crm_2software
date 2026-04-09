class AddCajaToDocumentoPagos < ActiveRecord::Migration[5.1]
  def change
    add_reference :documento_pagos, :caja, foreign_key: true
  end
end
