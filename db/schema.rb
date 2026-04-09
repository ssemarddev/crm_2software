# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20260409040333) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aparatos", force: :cascade do |t|
    t.string "serie"
    t.string "cov"
    t.bigint "bodega_id"
    t.string "serie_remplazo"
    t.string "cov_remplazo"
    t.integer "proveedor"
    t.integer "cliente"
    t.bigint "estado_id"
    t.string "comentario"
    t.boolean "status"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bodega_id"], name: "index_aparatos_on_bodega_id"
    t.index ["estado_id"], name: "index_aparatos_on_estado_id"
  end

  create_table "auto_sats", id: :integer, default: nil, force: :cascade do |t|
    t.integer "Numero_autorizacion"
    t.text "Serie"
    t.integer "Actual"
    t.integer "Inicio"
    t.integer "Fin"
    t.integer "Bodega_id"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["Bodega_id"], name: "index_auto_sats_on_Bodega_id"
  end

  create_table "bancos", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bodegas", id: :integer, default: nil, force: :cascade do |t|
    t.text "Nombre"
    t.text "Direccion"
    t.integer "Usuario_id"
    t.integer "Telefono"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["Usuario_id"], name: "index_bodegas_on_Usuario_id"
  end

  create_table "bodegausers", force: :cascade do |t|
    t.bigint "bodega_id"
    t.bigint "usuario_id"
    t.boolean "status"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bodega_id"], name: "index_bodegausers_on_bodega_id"
    t.index ["usuario_id"], name: "index_bodegausers_on_usuario_id"
  end

  create_table "cajas", force: :cascade do |t|
    t.string "Nombre"
    t.bigint "usuario_id"
    t.float "InicialEfectivo"
    t.float "FinalEfectivo"
    t.float "FinalPos"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tipo"
    t.index ["usuario_id"], name: "index_cajas_on_usuario_id"
  end

  create_table "calidads", force: :cascade do |t|
    t.string "nombre"
    t.boolean "status"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cliente_proveedors", id: :integer, default: nil, force: :cascade do |t|
    t.integer "Tipo"
    t.text "Nombre"
    t.text "Moneda"
    t.float "Tipo_Cambio"
    t.float "Porcentaje_Comision"
    t.integer "Destino"
    t.integer "Fax"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nit"
    t.text "direccion"
    t.string "clasificacion"
    t.string "observacion"
    t.string "municipio"
    t.bigint "ruta_id"
    t.index ["ruta_id"], name: "index_cliente_proveedors_on_ruta_id"
  end

  create_table "detalle_documentos", id: :integer, default: nil, force: :cascade do |t|
    t.integer "Documento_id"
    t.integer "Producto_id"
    t.integer "Medida_id"
    t.integer "DetalleMedida_id"
    t.float "cantidad"
    t.text "descripcion"
    t.float "valor_compra"
    t.float "valor_venta"
    t.float "descuento"
    t.float "descuento_porcentaje"
    t.float "total"
    t.boolean "estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.date "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.index ["DetalleMedida_id"], name: "index_detalle_documentos_on_DetalleMedida_id"
    t.index ["Documento_id"], name: "index_detalle_documentos_on_Documento_id"
    t.index ["Medida_id"], name: "index_detalle_documentos_on_Medida_id"
    t.index ["Producto_id"], name: "index_detalle_documentos_on_Producto_id"
  end

  create_table "detalle_medidas", id: :integer, default: nil, force: :cascade do |t|
    t.text "Nombre"
    t.integer "Medida_id"
    t.float "Proporcion"
    t.float "Porcentaje_Ganancia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "estado"
    t.index ["Medida_id"], name: "index_detalle_medidas_on_Medida_id"
  end

  create_table "detallecajas", force: :cascade do |t|
    t.bigint "caja_id"
    t.float "cantidad"
    t.integer "tipo"
    t.string "razon"
    t.boolean "status"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["caja_id"], name: "index_detallecajas_on_caja_id"
  end

  create_table "documento_pagos", id: :integer, default: nil, force: :cascade do |t|
    t.integer "Documento_id"
    t.integer "ClienteProveedor_id"
    t.integer "Tarjeta_id"
    t.boolean "Pagado"
    t.float "Deuda"
    t.float "Pago_Efectivo"
    t.float "Pago_Tarjeta"
    t.integer "Numero_Tarjeta"
    t.text "Nombre_Targeta"
    t.float "Interes"
    t.float "Mora"
    t.float "Total_Pagado"
    t.integer "Tipo_Documento"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.date "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "cambio"
    t.date "fechaLimite"
    t.float "abonos"
    t.float "deuda"
    t.float "pagos"
    t.integer "cuotas"
    t.string "referencia"
    t.bigint "tipo_pago_id"
    t.bigint "banco_id"
    t.string "boleta"
    t.float "pago_deposito"
    t.bigint "caja_id"
    t.index ["ClienteProveedor_id"], name: "index_documento_pagos_on_ClienteProveedor_id"
    t.index ["Documento_id"], name: "index_documento_pagos_on_Documento_id"
    t.index ["Tarjeta_id"], name: "index_documento_pagos_on_Tarjeta_id"
    t.index ["banco_id"], name: "index_documento_pagos_on_banco_id"
    t.index ["caja_id"], name: "index_documento_pagos_on_caja_id"
    t.index ["tipo_pago_id"], name: "index_documento_pagos_on_tipo_pago_id"
  end

  create_table "documentos", id: :integer, default: nil, force: :cascade do |t|
    t.date "Fecha_Entrega"
    t.date "Fecha_Recibido"
    t.text "Serie"
    t.text "Factura"
    t.integer "Documento"
    t.integer "ClienteProveedor_id"
    t.integer "TipoDocumento_id"
    t.integer "TipoPago_id"
    t.integer "Usuario_enviado_id"
    t.integer "Usuario_recibido_id"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "Estado"
    t.integer "status"
    t.bigint "ruta_id"
    t.string "nombreEntrega"
    t.string "direccionEntrega"
    t.string "numeroEntrega"
    t.string "piloto"
    t.integer "nitEntrega"
    t.index ["ClienteProveedor_id"], name: "index_documentos_on_ClienteProveedor_id"
    t.index ["TipoDocumento_id"], name: "index_documentos_on_TipoDocumento_id"
    t.index ["TipoPago_id"], name: "index_documentos_on_TipoPago_id"
    t.index ["Usuario_enviado_id"], name: "index_documentos_on_Usuario_enviado_id"
    t.index ["Usuario_recibido_id"], name: "index_documentos_on_Usuario_recibido_id"
    t.index ["ruta_id"], name: "index_documentos_on_ruta_id"
  end

  create_table "empresas", force: :cascade do |t|
    t.string "logo"
    t.string "direccion"
    t.string "nombre"
    t.string "color1"
    t.string "color2"
    t.boolean "status"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "version"
    t.boolean "facturaNegativos"
    t.boolean "pagoContraEntrega"
    t.string "bankAccounts"
    t.integer "wtpNumber"
    t.integer "nit"
    t.string "domain"
    t.string "courierdomain"
    t.string "politicatracking"
    t.string "politicaventa"
    t.boolean "desplegableProducto"
    t.boolean "desplegableNit"
    t.string "addressInfo"
  end

  create_table "estadortackings", force: :cascade do |t|
    t.bigint "tracking_id"
    t.bigint "estado_id"
    t.string "comentario"
    t.boolean "status"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estado_id"], name: "index_estadortackings_on_estado_id"
    t.index ["tracking_id"], name: "index_estadortackings_on_tracking_id"
  end

  create_table "estados", force: :cascade do |t|
    t.string "Nombre"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tipo"
  end

  create_table "marcas", id: :integer, default: nil, force: :cascade do |t|
    t.text "Nombre"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medidas", id: :integer, default: nil, force: :cascade do |t|
    t.text "Nombre"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movimiento_productos", id: :integer, default: nil, force: :cascade do |t|
    t.integer "Producto_id"
    t.integer "Saliente_Bodega_id"
    t.integer "Entrante_Bodega_id"
    t.integer "cantidad"
    t.float "porcentaje_proporcion"
    t.integer "movimiento_tipo"
    t.text "signo"
    t.integer "Documento_id"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.date "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "Estado"
    t.float "porcentaje_ganancia"
    t.bigint "detalle_documento_id"
    t.integer "status"
    t.index ["Documento_id"], name: "index_movimiento_productos_on_Documento_id"
    t.index ["Entrante_Bodega_id"], name: "index_movimiento_productos_on_Entrante_Bodega_id"
    t.index ["Producto_id"], name: "index_movimiento_productos_on_Producto_id"
    t.index ["Saliente_Bodega_id"], name: "index_movimiento_productos_on_Saliente_Bodega_id"
    t.index ["detalle_documento_id"], name: "index_movimiento_productos_on_detalle_documento_id"
  end

  create_table "opcion_roles", id: :integer, default: nil, force: :cascade do |t|
    t.integer "opcion_id"
    t.integer "role_id"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["opcion_id"], name: "index_opcion_roles_on_opcion_id"
    t.index ["role_id"], name: "index_opcion_roles_on_role_id"
  end

  create_table "opcions", id: :integer, default: nil, force: :cascade do |t|
    t.text "Nombre"
    t.text "LetraConjunto"
    t.text "Conjunto"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pagos", force: :cascade do |t|
    t.float "cantidad"
    t.bigint "documento_pago_id"
    t.string "referencia"
    t.float "interes"
    t.float "mora"
    t.string "observacion"
    t.boolean "status"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["documento_pago_id"], name: "index_pagos_on_documento_pago_id"
  end

  create_table "product_images", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.bigint "Producto_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["Producto_id"], name: "index_product_images_on_Producto_id"
  end

  create_table "productos", id: :integer, default: nil, force: :cascade do |t|
    t.text "Codigo"
    t.text "Nombre"
    t.integer "Marca_id"
    t.integer "ClienteProveedor_id"
    t.integer "TipoProducto_id"
    t.integer "Minimos"
    t.float "Valor_Compra"
    t.float "Valor_Venta"
    t.integer "Medida_id"
    t.text "Fila"
    t.text "Columna"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "estado"
    t.string "link"
    t.float "preciouno"
    t.float "preciodos"
    t.float "preciotres"
    t.float "preciocuatro"
    t.index ["ClienteProveedor_id"], name: "index_productos_on_ClienteProveedor_id"
    t.index ["Marca_id"], name: "index_productos_on_Marca_id"
    t.index ["Medida_id"], name: "index_productos_on_Medida_id"
    t.index ["TipoProducto_id"], name: "index_productos_on_TipoProducto_id"
  end

  create_table "proyectos", force: :cascade do |t|
    t.string "nombre"
    t.boolean "estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.datetime "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "role_usuarios", id: :integer, default: nil, force: :cascade do |t|
    t.integer "role_id"
    t.integer "usuario_id"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_role_usuarios_on_role_id"
    t.index ["usuario_id"], name: "index_role_usuarios_on_usuario_id"
  end

  create_table "roles", id: :integer, default: nil, force: :cascade do |t|
    t.text "Nombre"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ruta", force: :cascade do |t|
    t.string "nombre"
    t.string "piloto"
    t.boolean "status"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tipo"
  end

  create_table "solicitud_resurtidos", force: :cascade do |t|
    t.integer "Producto_id", null: false
    t.integer "cantidad_sugerida", default: 1
    t.string "telefono_solicitante"
    t.text "comentario"
    t.boolean "Estado", default: true
    t.integer "status", default: 1
    t.integer "solicitado_por"
    t.integer "atendido_por"
    t.datetime "atendido_en"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["Producto_id"], name: "index_solicitud_resurtidos_on_Producto_id"
    t.index ["status"], name: "index_solicitud_resurtidos_on_status"
  end

  create_table "sqlite_sequence", id: false, force: :cascade do |t|
    t.text "name"
    t.text "seq"
  end

  create_table "subproyectos", force: :cascade do |t|
    t.string "nombre"
    t.bigint "proyecto_id"
    t.boolean "estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.datetime "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proyecto_id"], name: "index_subproyectos_on_proyecto_id"
  end

  create_table "tareas", force: :cascade do |t|
    t.string "nombre"
    t.bigint "proyecto_id"
    t.bigint "subproyecto_id"
    t.string "descripcion", limit: 5000
    t.boolean "estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.datetime "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "usuario_id"
    t.date "fechafin"
    t.date "fecha_finalizado"
    t.index ["proyecto_id"], name: "index_tareas_on_proyecto_id"
    t.index ["subproyecto_id"], name: "index_tareas_on_subproyecto_id"
    t.index ["usuario_id"], name: "index_tareas_on_usuario_id"
  end

  create_table "tarjeta_creditos", id: :integer, default: nil, force: :cascade do |t|
    t.text "nombre"
    t.boolean "estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.date "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_documentos", id: :integer, default: nil, force: :cascade do |t|
    t.text "Nombre"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.date "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_pagos", id: :integer, default: nil, force: :cascade do |t|
    t.text "Nombre"
    t.text "Moneda"
    t.float "Tipo_Cambio"
    t.float "Porcentaje_Comision"
    t.integer "Destino"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_productos", id: :integer, default: nil, force: :cascade do |t|
    t.text "Nombre"
    t.boolean "Es_Servicio"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trackings", force: :cascade do |t|
    t.string "numero"
    t.string "descripcion"
    t.string "direccionOrigen"
    t.string "direccionDestion"
    t.bigint "cliente_proveedor_id"
    t.bigint "estado_id"
    t.boolean "state"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "serie"
    t.bigint "marca_id"
    t.string "observacion"
    t.string "falla"
    t.string "nombre_cliente"
    t.string "clave"
    t.integer "numero_contacto"
    t.float "precio"
    t.index ["cliente_proveedor_id"], name: "index_trackings_on_cliente_proveedor_id"
    t.index ["estado_id"], name: "index_trackings_on_estado_id"
    t.index ["marca_id"], name: "index_trackings_on_marca_id"
  end

  create_table "usuarios", id: :integer, default: nil, force: :cascade do |t|
    t.text "User_Name"
    t.text "password_digest"
    t.datetime "Ultimo_Login"
    t.text "Nombres"
    t.text "Apellidos"
    t.text "Correo"
    t.date "Fecha_Nacimiento"
    t.string "Telefono"
    t.string "Telefono1"
    t.float "Porcentaje_Descuento"
    t.boolean "Estado"
    t.integer "creado_por"
    t.integer "actualizado_por"
    t.date "creado"
    t.datetime "actualizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "Nivel_Acceso"
  end

  add_foreign_key "aparatos", "bodegas"
  add_foreign_key "aparatos", "estados"
  add_foreign_key "bodegausers", "bodegas"
  add_foreign_key "bodegausers", "usuarios"
  add_foreign_key "cajas", "usuarios"
  add_foreign_key "cliente_proveedors", "ruta", column: "ruta_id"
  add_foreign_key "detallecajas", "cajas"
  add_foreign_key "documento_pagos", "bancos"
  add_foreign_key "documento_pagos", "cajas"
  add_foreign_key "documento_pagos", "tipo_pagos"
  add_foreign_key "documentos", "ruta", column: "ruta_id"
  add_foreign_key "estadortackings", "estados"
  add_foreign_key "estadortackings", "trackings"
  add_foreign_key "movimiento_productos", "detalle_documentos"
  add_foreign_key "pagos", "documento_pagos"
  add_foreign_key "solicitud_resurtidos", "productos", column: "Producto_id"
  add_foreign_key "subproyectos", "proyectos"
  add_foreign_key "tareas", "proyectos"
  add_foreign_key "tareas", "subproyectos"
  add_foreign_key "tareas", "usuarios"
  add_foreign_key "trackings", "cliente_proveedors"
  add_foreign_key "trackings", "estados"
  add_foreign_key "trackings", "marcas"
end
