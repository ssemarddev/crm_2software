json.extract! cliente_proveedor, :id, :Tipo, :Nombre, :Moneda, :Tipo_Cambio, :Porcentaje_Comision, :Destino, :Fax, :Estado, :creado_por, :actualizado_por, :creado, :actualizado, :created_at, :updated_at
json.url cliente_proveedor_url(cliente_proveedor, format: :json)
