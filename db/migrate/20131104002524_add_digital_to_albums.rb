class AddDigitalToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :digital, :boolean, :null => false, :default => false
  end
end
