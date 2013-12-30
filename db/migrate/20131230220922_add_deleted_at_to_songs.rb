class AddDeletedAtToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :deleted_at, :datetime
  end
end
