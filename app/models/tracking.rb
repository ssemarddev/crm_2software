class Tracking < ApplicationRecord
  belongs_to :cliente_proveedor, :class_name => 'ClienteProveedor', optional: true
  belongs_to :estado, :class_name => 'Estado'
  before_save do
    self.creado           = Time.now.strftime("%Y-%m-%d")
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
  before_update do
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
end
