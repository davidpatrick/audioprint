class ChangePostFormatInBlogPost < ActiveRecord::Migration
  def up
    change_column :blog_posts, :post, :text, :limit => nil
  end

  def down
    change_column :blog_posts, :post, :string
  end
end

