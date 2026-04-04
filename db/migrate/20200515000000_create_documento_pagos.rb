class CreateDocumentoPagos < ActiveRecord::Migration[5.1]
  def change
    create_table :documento_pagos do |t|
      t.bigint  :Documento_id
      t.bigint  :ClienteProveedor_id
      t.bigint  :Tarjeta_id
      t.float   :Pagado
      t.float   :Deuda
      t.float   :Pago_Efectivo
      t.float   :Pago_Tarjeta
      t.string  :Numero_Tarjeta
      t.string  :Nombre_Targeta
      t.float   :Interes
      t.float   :Mora
      t.float   :Total_Pagado
      t.string  :Tipo_Documento
      t.boolean :Estado
      t.integer :creado_por
      t.integer :actualizado_por
      t.date    :creado
      t.datetime :actualizado

      t.timestamps
    end

    add_index :documento_pagos, :Documento_id
    add_index :documento_pagos, :ClienteProveedor_id
    add_index :documento_pagos, :Tarjeta_id
  end
end
