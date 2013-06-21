class RemoveMp3FromSong < ActiveRecord::Migration
  def up
    remove_column :songs, :mp3
  end

  def down
    add_column :songs, :mp3, :string
  end
end
