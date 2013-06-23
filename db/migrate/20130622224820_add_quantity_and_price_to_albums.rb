class AddQuantityAndPriceToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :quantity, :integer, null: false, default: 0
    add_column :albums, :price, :decimal, scale: 2, precision: 7, null: false, default: 0
  end
end
