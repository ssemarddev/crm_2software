class Rutum < ApplicationRecord
  validates :nombre, :presence => true
  has_many :ClienteProveedor, :dependent => :restrict_with_error,  primary_key: :id, foreign_key: :ruta_id

    before_save do
      self.creado           = Time.now.strftime("%Y-%m-%d")
      self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end
    before_update do
      self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end
end
