class AddCategoryIdToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :category_id, :integer
  end
end
