class Producto < ApplicationRecord
  belongs_to :Marca
  belongs_to :ClienteProveedor
  belongs_to :TipoProducto
  belongs_to :Medida
  
  has_many :product_image, class_name: ProductImage, foreign_key: :Producto_id
  has_many   :MovimientoProducto, dependent: :restrict_with_error, primary_key: :id, foreign_key: :Producto_id
  has_many   :DetalleDocumentos, dependent: :restrict_with_error,  primary_key: :id, foreign_key: :Producto_id

  validates :Codigo, presence: true, uniqueness: { case_sensitive: false }
  validates :Valor_Venta, numericality: true, presence: true
  validates :Valor_Compra, numericality: true, presence: true

  before_save do
    self.created_at = Time.now.strftime('%Y-%m-%d')
    self.updated_at      = Time.now.strftime('%Y-%m-%d %H:%M:%S')
  end
  before_update do
    self.updated_at      = Time.now.strftime('%Y-%m-%d %H:%M:%S')
  end

  def stock_total_actual
    entradas = MovimientoProducto.where(
      Producto_id: self.id,
      Estado: true,
      status: 1,
      signo: '+'
    ).sum(:cantidad).to_f

    salidas = MovimientoProducto.where(
      Producto_id: self.id,
      Estado: true,
      status: 1,
      signo: '-'
    ).sum(:cantidad).to_f

    entradas - salidas
  end

end
