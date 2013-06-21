class AddDownloadsToSong < ActiveRecord::Migration
  def change
    add_column :songs, :downloads, :integer, :null => false, :default => 0
  end
end