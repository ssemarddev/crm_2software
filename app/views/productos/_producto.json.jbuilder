json.extract! producto, :id, :Codigo, :Nombre, :Marca_id, :ClienteProveedor_id, :TipoProducto_id, :Minimos, :Valor_Compra, :Valor_Venta, :Medida_id, :Fila, :Columna, :created_at, :updated_at
json.url producto_url(producto, format: :json)
