class AddCambioToDocumentopagos < ActiveRecord::Migration[5.1]
  def change
    add_column :documento_pagos, :cambio, :float
  end
end
