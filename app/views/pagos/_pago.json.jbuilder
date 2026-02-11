json.extract! pago, :id, :cantidad, :documento_pago_id, :referencia, :interes, :mora, :observacion, :status, :creado_por, :actualizado_por, :creado, :actualizado, :created_at, :updated_at
json.url pago_url(pago, format: :json)
