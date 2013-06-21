class AddProfileTypeIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_type_id, :integer
  end
end
