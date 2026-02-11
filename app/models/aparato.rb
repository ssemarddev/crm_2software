class Aparato < ApplicationRecord
  belongs_to :bodega
  belongs_to :estado
  validates :proveedor, :presence => true
  validates :serie, :presence => true, uniqueness: { case_sensitive: false }
  validates :cov, :presence => true, uniqueness: { case_sensitive: false } 
  #belongs_to :proveedor, :class_name => 'ClienteProveedor'
  #belongs_to :cliente, :class_name => 'ClienteProveedor', optional: true
  before_save do
    self.creado           = Time.now.strftime("%Y-%m-%d")
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
  before_update do
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
end
