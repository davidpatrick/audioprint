class Song < ActiveRecord::Base
  resourcify
  attr_accessible :album_id, :artist, :length, :title, :size, :mp3, :track, :price, :catalog_id
  validates_presence_of :album_id, :title, :length
  belongs_to :album, touch: true
  has_many :order_items, :dependent => :destroy

  serialize :metadata
  has_attached_file :mp3, PAPERCLIP_MP3_OPTS
  validates_attachment_size :mp3, :less_than => 20.megabytes
  validates_attachment_content_type :mp3, :content_type => [ 'application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3' ]

  # def audio?
  #   mp3_content_type =~ %r{^audio/(?:mp3|mpeg|mpeg3|mpg|x-mp3|x-mpeg|x-mpeg3|x-mpegaudio|x-mpg)$}
  # end

  def digital
    true
  end

  def to_s
    self.title
  end

  def cover_art(size)
    self.album.cover_art(size)
  end

  def display_catalog_id
    "SNG##{id}"
  end

  def display_length
    Time.at(self.length).utc.strftime("%M:%S") if self.length
  end

  def download_url
    self.mp3.expiring_url(20)
  end

  def downloadable?(user)
    if user.has_role? :admin
      return true
    elsif user.has_role? :admin, self
      return true
    else
      return false
    end
  end

  def extract_metadata
    return unless mp3
    path = mp3.queued_for_write[:original].path
    open_opts = { :encoding => 'utf-8' }
    Mp3Info.open(path, open_opts) do |mp3info|
      self.metadata = mp3info.tag
      self.length = mp3info.length
    end

    if self.metadata
      self.title = self.metadata["title"]
      self.artist = self.metadata["artist"]
      self.track = self.metadata["tracknum"]
      true
    end
  end
end
