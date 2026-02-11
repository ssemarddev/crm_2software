class AddLinkToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :productos, :link, :string
  end
end
