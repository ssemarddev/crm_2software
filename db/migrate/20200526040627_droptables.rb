class Droptables < ActiveRecord::Migration[5.1]
  def change
    drop_table :estadorackings
    drop_table :trackings
  end
end
