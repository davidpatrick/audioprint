class BlogPost < ActiveRecord::Base
  attr_accessible :external_links, :post, :title
  acts_as_url :title, url_attribute: :slug
  validates_presence_of :post, :title
  validates_attachment :blog_cover, presence: true, content_type: { content_type: "image/jpg" }
  has_attached_file :blog_cover, PAPERCLIP_BLOG_OPTS

  def to_param
    "#{created_at.year}/#{created_at.month}/#{slug}"
  end
end
