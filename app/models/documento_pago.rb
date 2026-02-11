class DocumentoPago < ApplicationRecord
  belongs_to :Documento, optional: true
  belongs_to :ClienteProveedor
  belongs_to :banco, optional: true
  has_many :pago, -> { order(created_at: :desc) }
  #belongs_to :TarjetaCredito
  before_save do
    self.creado           = Time.now.strftime("%Y-%m-%d")
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
  before_update do
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
end
