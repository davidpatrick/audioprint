class AddAttachmentBlogCoverToBlogPosts < ActiveRecord::Migration
  def self.up
    change_table :blog_posts do |t|
      t.attachment :blog_cover
    end
  end

  def self.down
    drop_attached_file :blog_posts, :blog_cover
  end
end
