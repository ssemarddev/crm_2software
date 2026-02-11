json.extract! tipo_documento, :id, :Nombre, :Estado, :creado_por, :actualizado_por, :creado, :actualizado, :created_at, :updated_at
json.url tipo_documento_url(tipo_documento, format: :json)
