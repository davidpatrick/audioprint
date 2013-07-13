class AddSoundcloudUrlToBlogPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :soundcloud_url, :string
  end
end
