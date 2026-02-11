class RoleUsuario < ApplicationRecord
  belongs_to :role
  belongs_to :usuario
  validates :role, :presence => true, uniqueness: { case_sensitive: false ,  scope: :usuario }
  validates :usuario, :presence => true, uniqueness: { case_sensitive: false , scope: :role }
    before_save do
      self.creado           = Time.now.strftime("%Y-%m-%d")
      self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end
    before_update do
      self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end
end
