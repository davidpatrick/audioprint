class ChangeAlbumAlbumTypeToString < ActiveRecord::Migration
  def change
    change_column :albums, :album_type, :string
  end
end
