class Caja < ApplicationRecord
  belongs_to :usuario, :class_name => 'Usuario'
  validates :Nombre, uniqueness: { scope: [:Nombre,:usuario] }, :presence => true
  before_save do
    self.creado           = Time.now.strftime("%Y-%m-%d")
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
  before_update do
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
end
