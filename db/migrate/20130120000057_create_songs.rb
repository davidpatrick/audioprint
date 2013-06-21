class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name
      t.string :artist
      t.integer :length
      t.integer :size
      t.integer :album_id

      t.timestamps
    end
  end
end
