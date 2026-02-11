json.extract! tipo_producto, :id, :Nombre, :Es_Servicio, :Estado, :creado_por, :actualizado_por, :creado, :actualizado, :created_at, :updated_at
json.url tipo_producto_url(tipo_producto, format: :json)
