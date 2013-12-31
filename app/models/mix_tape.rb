class MixTape < Album
  before_create :save_artist

  def save_artist
    self.artist = 'Various Artists'
  end

  def to_s
    self.title
  end
end
