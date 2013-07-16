class RenameAlbumYearToReleaseDate < ActiveRecord::Migration
  def change
    rename_column :albums, :year, :release_date
  end
end
