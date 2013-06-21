class AddQuantityToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :quantity, :integer
    add_column :albums, :price, :decimal, scale: 2, precision: 7
  end
end
