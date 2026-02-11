class AddPreciounoPreciodosPreciotresPreciocuatroToProductos < ActiveRecord::Migration[5.1]
  def change
    add_column :productos, :preciouno, :float
    add_column :productos, :preciodos, :float
    add_column :productos, :preciotres, :float
    add_column :productos, :preciocuatro, :float
  end
end
