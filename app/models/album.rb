class Album < ActiveRecord::Base
  resourcify
  validates_presence_of :title, :artist, :catalog_id, :price
  attr_accessible :artist, :cover_art, :title, :release_date, :quantity, :price, :catalog_id, :category_id, :digital
  has_many :songs, :dependent => :destroy
  has_many :order_items
  belongs_to :user
  belongs_to :category
  delegate :name, :to => :category, :allow_nil => true, :prefix => true #album.category_name

  has_attached_file :cover_art, PAPERCLIP_COVER_ART_OPTS

  validates_uniqueness_of :catalog_id
  validates_attachment_size :cover_art, :less_than => 2.megabytes
  validates_attachment_content_type :cover_art, :content_type => ['image/jpeg', 'image/png']

  def to_s
    self.artist + ' - ' + self.title
  end

  def track_list
    self.songs.order('track')
  end
end
