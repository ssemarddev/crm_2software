class Bodega < ApplicationRecord
  has_many :AutoSat , :dependent => :restrict_with_error
  has_many :MovimientoProducto  , :dependent => :restrict_with_error
  belongs_to :Usuario
  validates :Nombre, :presence => true, uniqueness: { case_sensitive: false } #, { scope: :year } }
    before_save do
      self.creado           = Time.now.strftime("%Y-%m-%d")
      self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end
    before_update do
      self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end
end
