class OrderItem < ActiveRecord::Base
  attr_accessible :order_id, :product_id, :product_type, :quantity
  belongs_to :order
  belongs_to :product, polymorphic: true
  validates_presence_of :order_id, :product_id, :product_type, :quantity
  validate :validate_quantity, :if => Proc.new{|item| item.product_type == 'Album' }

  def validate_quantity
    if quantity > product.quantity
      errors.add(:quantity, 'not enough in stock')
      return false
    else
      return true
    end
  end


  def subtotal
    (quantity * product.price).to_f
  end
end
