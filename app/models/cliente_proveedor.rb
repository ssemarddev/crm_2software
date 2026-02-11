class ClienteProveedor < ApplicationRecord
  has_many :Producto, :dependent => :restrict_with_error,  primary_key: :id, foreign_key: :ClienteProveedor_id
  has_many :Documento, :dependent => :restrict_with_error,  primary_key: :id, foreign_key: :ClienteProveedor_id
  has_many :Tracking, :dependent => :restrict_with_error,  primary_key: :id, foreign_key: :ClienteProveedor_id
  validates :nit, :presence => true, uniqueness: { case_sensitive: false , scope: :Tipo  }
  validates :Nombre, :presence => true
  before_save do
    self.creado           = Time.now.strftime("%Y-%m-%d")
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
  before_update do
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end

  def formatted_name
    "#{Nombre} - #{direccion} - #{municipio}"
  end
end
