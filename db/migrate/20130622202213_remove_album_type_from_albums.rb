class RemoveAlbumTypeFromAlbums < ActiveRecord::Migration
  def up
    remove_column :albums, :album_type
  end

  def down
    add_column :albums, :album_type, :integer
  end
end
