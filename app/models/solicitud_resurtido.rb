class SolicitudResurtido < ApplicationRecord
  belongs_to :Producto, class_name: 'Producto'

  scope :pendientes, -> { where(Estado: true, status: 1).order(created_at: :desc) }

  validates :Producto_id, presence: true

  before_save do
    self.creado     = Time.now.strftime("%Y-%m-%d")
    self.actualizado = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    self.cantidad_sugerida = 1 if self.cantidad_sugerida.blank? || self.cantidad_sugerida.to_i <= 0
    self.Estado = true if self.Estado.nil?
    self.status = 1 if self.status.nil?
  end

  before_update do
    self.actualizado = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
end