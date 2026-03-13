class DashboardController < ApplicationController
  def index
    @fecha_inicio = parse_date(params[:fecha_inicio], Date.current.beginning_of_month)
    @fecha_fin    = parse_date(params[:fecha_fin], Date.current)
    @bodega_id    = params[:bodega_id].presence
    @usuario_id   = params[:usuario_id].presence

    @bodegas  = Bodega.where(Estado: true).order('"Nombre"')
    @usuarios = Usuario.where(Estado: true).order('"Nombres"')

    detalle_scope = base_detalle_ventas_scope
    @ventas_detalle = detalle_scope.to_a

    documento_ids = @ventas_detalle.map(&:Documento_id).uniq
    documentos_venta = Documento.where(id: documento_ids)

    ventas_total     = @ventas_detalle.sum { |r| r.total.to_f }
    unidades_total   = @ventas_detalle.sum { |r| r.cantidad.to_f }
    descuento_total  = @ventas_detalle.sum { |r| r.descuento.to_f }
    utilidad_total   = @ventas_detalle.sum { |r| r.total.to_f - (r.cantidad.to_f * r.valor_compra.to_f) }
    documentos_total = documento_ids.size
    clientes_total   = documentos_venta.where.not(ClienteProveedor_id: nil).distinct.count(:ClienteProveedor_id)
    vendedores_total = documentos_venta.where.not(Usuario_enviado_id: nil).distinct.count(:Usuario_enviado_id)
    ticket_promedio  = documentos_total > 0 ? (ventas_total / documentos_total) : 0

    cobrado_total = 0
    unless documento_ids.empty?
      cobrado_total = DocumentoPago.where(Documento_id: documento_ids, Estado: true).sum(:Total_Pagado).to_f
    end

    por_cobrar_total = ventas_total - cobrado_total

    stock_rows = current_stock_rows
    inventario_valorizado = stock_rows.sum do |row|
      existencias = row[:existencias].to_f
      costo = row[:valor_compra].to_f
      existencias > 0 ? (existencias * costo) : 0
    end

    @kpis = {
      ventas_total: ventas_total,
      utilidad_total: utilidad_total,
      documentos_total: documentos_total,
      ticket_promedio: ticket_promedio,
      clientes_total: clientes_total,
      vendedores_total: vendedores_total,
      unidades_total: unidades_total,
      descuento_total: descuento_total,
      cobrado_total: cobrado_total,
      por_cobrar_total: por_cobrar_total,
      inventario_valorizado: inventario_valorizado,
      productos_stock_critico: stock_rows.count { |r| r[:existencias].to_f <= r[:minimos].to_f }
    }

    ventas_por_dia = detalle_scope
      .group(Arel.sql('DATE("doc"."Fecha_Entrega")'))
      .order(Arel.sql('DATE("doc"."Fecha_Entrega")'))
      .pluck(
        Arel.sql('DATE("doc"."Fecha_Entrega")'),
        Arel.sql('COALESCE(SUM("detalle_documentos"."total"), 0)')
      )

    utilidad_por_dia = detalle_scope
      .group(Arel.sql('DATE("doc"."Fecha_Entrega")'))
      .order(Arel.sql('DATE("doc"."Fecha_Entrega")'))
      .pluck(
        Arel.sql('DATE("doc"."Fecha_Entrega")'),
        Arel.sql('COALESCE(SUM("detalle_documentos"."total" - ("detalle_documentos"."cantidad" * "detalle_documentos"."valor_compra")), 0)')
      )

    ventas_por_vendedor = detalle_scope
      .joins('LEFT JOIN "usuarios" "u" ON "u"."id" = "doc"."Usuario_enviado_id"')
      .group(Arel.sql('COALESCE("u"."Nombres", \'Sin vendedor\')'))
      .order(Arel.sql('COALESCE(SUM("detalle_documentos"."total"), 0) DESC'))
      .limit(10)
      .pluck(
        Arel.sql('COALESCE("u"."Nombres", \'Sin vendedor\')'),
        Arel.sql('COALESCE(SUM("detalle_documentos"."total"), 0)')
      )

    top_productos = detalle_scope
      .joins('INNER JOIN "productos" "prod" ON "prod"."id" = "detalle_documentos"."Producto_id"')
      .group(Arel.sql('"prod"."Nombre"'))
      .order(Arel.sql('COALESCE(SUM("detalle_documentos"."cantidad"), 0) DESC'))
      .limit(10)
      .pluck(
        Arel.sql('"prod"."Nombre"'),
        Arel.sql('COALESCE(SUM("detalle_documentos"."cantidad"), 0)')
      )

    ventas_por_tipo_pago = detalle_scope
      .joins('LEFT JOIN "tipo_pagos" "tp" ON "tp"."id" = "doc"."TipoPago_id"')
      .group(Arel.sql('COALESCE("tp"."Nombre", \'Sin tipo de pago\')'))
      .order(Arel.sql('COALESCE(SUM("detalle_documentos"."total"), 0) DESC'))
      .pluck(
        Arel.sql('COALESCE("tp"."Nombre", \'Sin tipo de pago\')'),
        Arel.sql('COALESCE(SUM("detalle_documentos"."total"), 0)')
      )

    ventas_por_bodega = detalle_scope
      .joins('INNER JOIN "movimiento_productos" "mprod" ON "mprod"."detalle_documento_id" = "detalle_documentos"."id"')
      .joins('LEFT JOIN "bodegas" "bod" ON "bod"."id" = "mprod"."Saliente_Bodega_id"')
      .group(Arel.sql('COALESCE("bod"."Nombre", \'Sin bodega\')'))
      .order(Arel.sql('COALESCE(SUM("detalle_documentos"."total"), 0) DESC'))
      .pluck(
        Arel.sql('COALESCE("bod"."Nombre", \'Sin bodega\')'),
        Arel.sql('COALESCE(SUM("detalle_documentos"."total"), 0)')
      )

    top_clientes = detalle_scope
      .joins('LEFT JOIN "cliente_proveedors" "cli" ON "cli"."id" = "doc"."ClienteProveedor_id"')
      .group(Arel.sql('COALESCE("cli"."Nombre", \'Cliente no definido\')'))
      .order(Arel.sql('COALESCE(SUM("detalle_documentos"."total"), 0) DESC'))
      .limit(10)
      .pluck(
        Arel.sql('COALESCE("cli"."Nombre", \'Cliente no definido\')'),
        Arel.sql('COALESCE(SUM("detalle_documentos"."total"), 0)')
      )

    @ventas_por_dia_labels   = ventas_por_dia.map { |r| format_label_date(r[0]) }
    @ventas_por_dia_values   = ventas_por_dia.map { |r| r[1].to_f.round(2) }

    @utilidad_por_dia_labels = utilidad_por_dia.map { |r| format_label_date(r[0]) }
    @utilidad_por_dia_values = utilidad_por_dia.map { |r| r[1].to_f.round(2) }

    @ventas_por_vendedor_labels = ventas_por_vendedor.map { |r| r[0].to_s }
    @ventas_por_vendedor_values = ventas_por_vendedor.map { |r| r[1].to_f.round(2) }

    @top_productos_labels = top_productos.map { |r| r[0].to_s }
    @top_productos_values = top_productos.map { |r| r[1].to_f.round(2) }

    @ventas_por_tipo_pago_labels = ventas_por_tipo_pago.map { |r| r[0].to_s }
    @ventas_por_tipo_pago_values = ventas_por_tipo_pago.map { |r| r[1].to_f.round(2) }

    @ventas_por_bodega_labels = ventas_por_bodega.map { |r| r[0].to_s }
    @ventas_por_bodega_values = ventas_por_bodega.map { |r| r[1].to_f.round(2) }

    @top_clientes = top_clientes.map do |nombre, total|
      { nombre: nombre, total: total.to_f.round(2) }
    end

    @stock_critico = stock_rows
      .select { |r| r[:existencias].to_f <= r[:minimos].to_f }
      .sort_by { |r| [r[:existencias].to_f, r[:minimos].to_f] }
      .first(10)
  end

  private

  def parse_date(value, default_value)
    return default_value if value.blank?
    Date.parse(value)
  rescue StandardError
    default_value
  end

  def format_label_date(value)
    return value.strftime('%d/%m/%Y') if value.respond_to?(:strftime)
    Date.parse(value.to_s).strftime('%d/%m/%Y')
  rescue StandardError
    value.to_s
  end

  def base_detalle_ventas_scope
    scope = DetalleDocumento
      .joins('INNER JOIN "documentos" "doc" ON "doc"."id" = "detalle_documentos"."Documento_id"')
      .where('"detalle_documentos"."estado" = true')
      .where('"detalle_documentos"."status" = 1')
      .where('"doc"."Estado" = true')
      .where('"doc"."TipoDocumento_id" = 2')
      .where('DATE("doc"."Fecha_Entrega") BETWEEN ? AND ?', @fecha_inicio, @fecha_fin)

    if @usuario_id.present?
      scope = scope.where('"doc"."Usuario_enviado_id" = ?', @usuario_id.to_i)
    end

    if @bodega_id.present?
      scope = scope.where(
        <<-SQL.squish, @bodega_id.to_i
          EXISTS (
            SELECT 1
            FROM "movimiento_productos" "mfilter"
            WHERE "mfilter"."detalle_documento_id" = "detalle_documentos"."id"
              AND "mfilter"."Saliente_Bodega_id" = ?
          )
        SQL
      )
    end

    scope
  end

  def current_stock_rows
    qty_expr = '("movimiento_productos"."cantidad" * COALESCE("movimiento_productos"."porcentaje_proporcion", 100) / 100.0)'

    stock_expr =
      if @bodega_id.present?
        <<-SQL.squish
          COALESCE(SUM(
            CASE
              WHEN "movimiento_productos"."Entrante_Bodega_id" = #{@bodega_id.to_i} THEN #{qty_expr}
              WHEN "movimiento_productos"."Saliente_Bodega_id" = #{@bodega_id.to_i} THEN -#{qty_expr}
              ELSE 0
            END
          ), 0)
        SQL
      else
        <<-SQL.squish
          COALESCE(SUM(
            CASE
              WHEN "movimiento_productos"."signo" = '+' THEN #{qty_expr}
              ELSE -#{qty_expr}
            END
          ), 0)
        SQL
      end

    rows = MovimientoProducto
      .joins('INNER JOIN "productos" "prod" ON "prod"."id" = "movimiento_productos"."Producto_id"')
      .where('"movimiento_productos"."Estado" = true')
      .where('"movimiento_productos"."status" = 1')
      .group(
        Arel.sql('"prod"."id"'),
        Arel.sql('"prod"."Codigo"'),
        Arel.sql('"prod"."Nombre"'),
        Arel.sql('"prod"."Minimos"'),
        Arel.sql('"prod"."Valor_Compra"')
      )
      .pluck(
        Arel.sql('"prod"."id"'),
        Arel.sql('"prod"."Codigo"'),
        Arel.sql('"prod"."Nombre"'),
        Arel.sql('COALESCE("prod"."Minimos", 0)'),
        Arel.sql('COALESCE("prod"."Valor_Compra", 0)'),
        Arel.sql(stock_expr)
      )

    rows.map do |row|
      {
        producto_id: row[0],
        codigo: row[1],
        nombre: row[2],
        minimos: row[3].to_f,
        valor_compra: row[4].to_f,
        existencias: row[5].to_f
      }
    end
  end
end