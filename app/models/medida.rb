class Medida < ApplicationRecord
  has_many :Producto , :dependent => :restrict_with_error,  primary_key: :id, foreign_key: :Medida_id
  has_many :DetalleMedida , :dependent => :restrict_with_error,  primary_key: :id, foreign_key: :Medida_id
  validates :Nombre, :presence => true, uniqueness: { case_sensitive: false } #, { scope: :year } }
  before_save do
    self.creado           = Time.now.strftime("%Y-%m-%d")
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
  before_update do
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
end
