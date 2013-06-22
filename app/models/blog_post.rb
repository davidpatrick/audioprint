class BlogPost < ActiveRecord::Base
  attr_accessible :external_links, :post, :title, :album_id, :blog_cover
  acts_as_url :title, url_attribute: :slug
  validates_presence_of :post, :title
  belongs_to :album

  validates_attachment :blog_cover, presence: true
  has_attached_file :blog_cover, PAPERCLIP_BLOG_OPTS

  def to_param
    "#{created_at.year}/#{created_at.month}/#{slug}"
  end
end
