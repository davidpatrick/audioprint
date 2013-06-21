class RemoveCoverArtFromAlbums < ActiveRecord::Migration
  def up
    remove_column :albums, :cover_art
  end

  def down
    add_column :albums, :cover_art, :string
  end
end
