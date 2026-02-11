json.extract! tipo_pago, :id, :Nombre, :Moneda, :Tipo_Cambio, :Porcentaje_Comision, :Destino, :Estado, :creado_por, :actualizado_por, :creado, :actualizado, :created_at, :updated_at
json.url tipo_pago_url(tipo_pago, format: :json)
