class CreateProfileTypes < ActiveRecord::Migration
  def change
    create_table :profile_types do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
