class OrderItem < ActiveRecord::Base
  attr_accessible :order_id, :product_id, :product_type, :quantity
  belongs_to :order
  belongs_to :product, polymorphic: true
  validates_presence_of :order_id, :product_id, :product_type, :quantity

  def subtotal
    (self.quantity * self.product.price).to_f
  end
end
