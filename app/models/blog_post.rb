class BlogPost < ActiveRecord::Base
  attr_accessible :external_links, :post, :title, :album_id
  acts_as_url :title, url_attribute: :slug
  validates_presence_of :post, :title
  belongs_to :album

  def to_param
    "#{created_at.year}/#{created_at.month}/#{slug}"
  end
end
