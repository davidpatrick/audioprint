class ChangeDateFormatInAlbums < ActiveRecord::Migration
  def self.up
   change_column :albums, :release_date, :date
  end

  def self.down
   change_column :albums, :release_date, :datetime
  end
end