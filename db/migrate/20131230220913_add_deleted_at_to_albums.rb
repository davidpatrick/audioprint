class AddDeletedAtToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :deleted_at, :datetime
  end
end
