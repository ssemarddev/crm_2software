json.extract! movimiento_producto, :id, :Producto_id, :Saliente_Bodega_id, :Entrante_Bodega_id, :cantidad, :porcentaje_proporcion, :movimiento_tipo, :signo, :Documento_id, :creado_por, :actualizado_por, :creado, :actualizado, :created_at, :updated_at
json.url movimiento_producto_url(movimiento_producto, format: :json)
