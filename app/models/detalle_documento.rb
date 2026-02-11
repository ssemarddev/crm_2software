class DetalleDocumento < ApplicationRecord
  belongs_to :Documento
  belongs_to :Producto
  belongs_to :Medida, optional: true
  belongs_to :DetalleMedida, optional: true
  has_one :movimiento_producto, class_name: "MovimientoProducto", foreign_key: "detalle_documento_id"

  before_save do
    self.creado           = Time.now.strftime("%Y-%m-%d")
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
  before_update do
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
end
