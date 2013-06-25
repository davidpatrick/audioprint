class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :product, :polymorphic => true
      t.integer :order_id
      t.integer :quantity

      t.timestamps
    end
  end
end
