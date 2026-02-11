class Usuario < ApplicationRecord
  #belongs_to :Usuario_id, :class_name => 'Bodega'
  #belongs_to :RoleUsuario
  #belongs_to :Documento
  validates :User_Name, :presence => true, uniqueness: { case_sensitive: false } #, { scope: :year } }
  validates :Porcentaje_Descuento, :presence => true# uniqueness: { case_sensitive: false } #, { scope: :year } }
  validates :Nivel_Acceso, :presence => true# uniqueness: { case_sensitive: false } #, { scope: :year } }
  validates :Nombres, :presence => true#, uniqueness: { case_sensitive: false } , { scope: :User_Name } }
  has_secure_password
    before_save do
      self.creado           = Time.now.strftime("%Y-%m-%d")
      self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end
    before_update do
      self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end
end
