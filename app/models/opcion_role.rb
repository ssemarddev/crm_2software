class OpcionRole < ApplicationRecord
  validates :opcion, :presence => true, uniqueness: { case_sensitive: false , scope: :role } 
  validates :role, :presence => true, uniqueness: { case_sensitive: false ,  scope: :opcion }
  belongs_to :opcion
  belongs_to :role
    before_save do
      self.creado           = Time.now.strftime("%Y-%m-%d")
      self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end
    before_update do
      self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end
end
