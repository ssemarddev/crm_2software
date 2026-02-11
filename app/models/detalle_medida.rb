class DetalleMedida < ApplicationRecord
  belongs_to :Medida
  before_save do
    self.created_at      = Time.now.strftime("%Y-%m-%d")
    self.updated_at      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
  before_update do
    self.updated_at      = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
end
