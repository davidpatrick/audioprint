class AddAccountRequestToUser < ActiveRecord::Migration
  def change
    add_column :users, :account_request, :integer
  end
end
