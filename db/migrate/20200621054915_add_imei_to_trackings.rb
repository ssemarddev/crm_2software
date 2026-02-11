class AddImeiToTrackings < ActiveRecord::Migration[5.1]
  def change
    add_column :trackings, :serie, :string
    add_reference :trackings, :marca, foreign_key: true
    add_column :trackings, :observacion, :string
    add_column :trackings, :falla, :string
  end
end
