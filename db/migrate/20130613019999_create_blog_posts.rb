class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.string :post
      t.string :slug

      t.timestamps
    end
  end
end
