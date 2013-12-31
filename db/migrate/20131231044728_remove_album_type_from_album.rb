class RemoveAlbumTypeFromAlbum < ActiveRecord::Migration
  def up
    remove_column :albums, :album_type, :string
  end
end
