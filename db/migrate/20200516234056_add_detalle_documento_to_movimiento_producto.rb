class AddDetalleDocumentoToMovimientoProducto < ActiveRecord::Migration[5.1]
  def change
    add_reference :movimiento_productos, :detalle_documento, foreign_key: true
  end
end
