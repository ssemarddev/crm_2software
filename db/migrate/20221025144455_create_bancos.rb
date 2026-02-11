class CreateBancos < ActiveRecord::Migration[5.1]
  def change
    create_table :bancos do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
