class AddAttachmentCoverArtToAlbums < ActiveRecord::Migration
  def self.up
    change_table :albums do |t|
      t.has_attached_file :cover_art
    end
  end

  def self.down
    drop_attached_file :albums, :cover_art
  end
end
