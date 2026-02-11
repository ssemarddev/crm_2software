json.extract! usuario, :id, :User_Name, :Ultimo_Login, :Nombres, :Apellidos, :Correo, :Fecha_Nacimiento, :Telefono, :Telefono1, :Porcentaje_Descuento, :Nivel_Acceso, :Estado, :creado_por, :actualizado_por, :creado, :actualizado, :created_at, :updated_at
json.url usuario_url(usuario, format: :json)
