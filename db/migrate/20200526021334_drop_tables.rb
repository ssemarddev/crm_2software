class DropTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :estado_trackings
    drop_table :trackings
  end
end
