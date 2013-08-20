class BlogPost < ActiveRecord::Base
  attr_accessible :external_links, :post, :title, :soundcloud_url, :blog_cover
  acts_as_url :title, url_attribute: :slug
  validates_presence_of :post, :title, :blog_cover
  belongs_to :album

  has_attached_file :blog_cover, PAPERCLIP_BLOG_OPTS

  def to_param
    "#{created_at.year}/#{created_at.month}/#{slug}"
  end
end
