class RemoveAlbumIdFromBlogPosts < ActiveRecord::Migration
  def up
    remove_column :blog_posts, :album_id
  end

  def down
    add_column :blog_posts, :album_id, :string
  end
end
