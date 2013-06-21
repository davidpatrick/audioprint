class AddAlbumIdToBlogPost < ActiveRecord::Migration
  def change
    add_column :blog_posts, :album_id, :integer
  end
end
