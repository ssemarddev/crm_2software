json.extract! documento, :id, :Fecha_Entrega, :Fecha_Recibido, :Serie, :Factura, :Documento, :ClienteProveedor_id, :TipoDocumento_id, :TipoPago_id, :Usuario_enviado_id, :Usuario_recibido_id, :creado_por, :actualizado_por, :created_at, :updated_at
json.url documento_url(documento, format: :json)
