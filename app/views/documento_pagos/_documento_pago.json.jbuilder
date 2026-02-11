json.extract! documento_pago, :id, :Documento_id, :ClienteProveedor_id, :Tarjeta_id, :Pagado, :Deuda, :Pago_Efectivo, :Pago_Tarjeta, :Numero_Tarjeta, :Nombre_Targeta, :Interes, :Mora, :Total_Pagado, :Tipo_Documento, :Estado, :creado_por, :actualizado_por, :creado, :actualizado, :created_at, :updated_at
json.url documento_pago_url(documento_pago, format: :json)
