json.extract! tarea, :id, :nombre, :proyecto_id, :subproyecto_id, :descripcion, :estado, :creado_por, :actualizado_por, :creado, :actualizado, :created_at, :updated_at
json.url tarea_url(tarea, format: :json)
