class MovimientoProducto < ApplicationRecord
  belongs_to :Producto
  belongs_to :Saliente_Bodega, :class_name => 'Bodega', optional: true
  belongs_to :Entrante_Bodega, :class_name => 'Bodega', optional: true
  belongs_to :Documento
  belongs_to :detalle_documento, class_name: 'DetalleDocumento'


  before_save do
    self.creado           = Time.now.strftime("%Y-%m-%d")
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
  before_update do
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
end
