class AddAlbumTypetoAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :album_type, :integer
  end
end
