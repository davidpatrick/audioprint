class AddTypeToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :type, :string, default: 'Album'
  end
end
