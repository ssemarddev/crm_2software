class Tarea < ApplicationRecord
  belongs_to :proyecto
  belongs_to :usuario
  belongs_to :subproyecto, optional: true
  
  before_save do
    self.creado           = Time.now.strftime("%Y-%m-%d")
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
  before_update do
    self.actualizado      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
end
