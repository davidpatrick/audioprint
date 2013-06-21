class Song < ActiveRecord::Base
  resourcify
  attr_accessible :album_id, :artist, :length, :title, :size, :mp3, :track
  belongs_to :album
  validates_presence_of :album_id, :title, :length

  serialize :metadata
  has_attached_file :mp3, PAPERCLIP_MP3_OPTS
  validates_attachment_size :mp3, :less_than => 20.megabytes
  validates_attachment_content_type :mp3, :content_type => [ 'application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3' ]

  # def audio?
  #   mp3_content_type =~ %r{^audio/(?:mp3|mpeg|mpeg3|mpg|x-mp3|x-mpeg|x-mpeg3|x-mpegaudio|x-mpg)$}
  # end

  # def display_name
  #   @display_name ||= if audio? && metadata?
  #     artist, title = metadata.values_at('artist', 'title')
  #     title.present? ? [title, artist].compact.join(' - ').force_encoding('UTF-8') : mp3_file_name
  #   else
  #     mp3_file_name
  #   end
  # end

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
end
