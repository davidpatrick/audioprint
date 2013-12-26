class Order < ActiveRecord::Base
  attr_accessible :status, :user, :address_id
  belongs_to :user, foreign_key: :user_id
  belongs_to :address, touch: true
  has_many :order_items, dependent: :destroy

  def self.status_types
    ["Unsubmitted", "Confirmed", "Processed", "Shipped"]
  end

  def total
    self.order_items.collect(&:subtotal).sum
  end

  def process(user)
    return false unless self.status == "Confirmed"
    if self.update_column(:status, "Processed")
      self.order_items.each do |item|
        product = item.product
        product.quantity = product.quantity - item.quantity
        # backorder = 0 - product.quantity if product.quantity < 0
        product.save
      end
      OrderMailer.process_order(user, self).deliver
      return true
    else
      return false
    end
  end


  def ship(user)
    return false unless @order.status == "Processed"
    if self.update_column(:status, "Shipped")
      OrderMailer.ship_order(user, self).deliver
      return true
    else
      return false
    end
  end
end
