class AddMp3ToSong < ActiveRecord::Migration
  def change
    add_column :songs, :mp3, :string
  end
end
