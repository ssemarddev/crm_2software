class CreateProductImages < ActiveRecord::Migration[5.1]
  def change
    create_table :product_images do |t|
      t.string :nombre
      t.string :descripcion
      t.references :Producto

      t.timestamps
    end
  end
end
