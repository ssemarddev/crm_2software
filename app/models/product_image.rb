class ProductImage < ApplicationRecord
  belongs_to :Producto, class_name: "Producto"
end
