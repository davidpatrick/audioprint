class AddShippingConfirmationToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_confirmation, :string
  end
end
