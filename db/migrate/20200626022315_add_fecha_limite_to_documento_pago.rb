class AddFechaLimiteToDocumentoPago < ActiveRecord::Migration[5.1]
  def change
    add_column :documento_pagos, :fechaLimite, :date
    add_column :documento_pagos, :abonos, :float
    add_column :documento_pagos, :deuda, :float
    add_column :documento_pagos, :pagos, :float
  end
end
