json.extract! detalle_documento, :id, :Documento_id, :Producto_id, :Medida_id, :DetalleMedida_id, :cantidad, :descripcion, :valor_compra, :valor_venta, :descuento, :descuento_porcentaje, :total, :Estado, :creado_por, :actualizado_por, :creado, :actualizado, :created_at, :updated_at
json.url detalle_documento_url(detalle_documento, format: :json)
