class AddPriceToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :price, :decimal, scale: 2, precision: 7, null: false, default: 0
  end
end
