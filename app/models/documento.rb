class Documento < ApplicationRecord
  belongs_to :ClienteProveedor, optional: true
  belongs_to :TipoDocumento
  belongs_to :TipoPago, optional: true
  belongs_to :Usuario_enviado , :class_name => 'Usuario', optional: true
  belongs_to :Usuario_recibido, :class_name => 'Usuario', optional: true
  has_many :detalle_documento, class_name: 'DetalleDocumento', foreign_key: 'Documento_id'
  has_many :movimiento_producto, class_name: 'MovimientoProducto', foreign_key: 'Documento_id'
end
