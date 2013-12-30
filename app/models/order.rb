class Order < ActiveRecord::Base
  attr_accessible :status, :user, :address_id, :shipping_confirmation
  belongs_to :user, foreign_key: :user_id
  belongs_to :address
  has_many :order_items, dependent: :destroy

  def self.status_types
    @@status_types ||= ["Unsubmitted", "Confirmed", "Processed", "Shipped"]
  end

  def is_valid?
    address.present?
  end

  def shipping_cost
    0
  end

  def sales_tax
    0
  end

  def subtotal
    self.order_items.collect(&:subtotal).sum
  end

  def total
    self.order_items.collect(&:subtotal).sum + shipping_cost + sales_tax
  end

  def confirm(customer, options={})
    if options[:stripe_card_token]
      self.update_column(:status, "Confirmed") if Stripe::Charge.create(
        :amount => (total * 100).to_i,
        :currency => "usd",
        :card => options[:stripe_card_token],
        :metadata => {
          order_id: id,
          customer_id: customer.id,
          customer_name: customer.name,
          shipping_address: address.to_s
        }
      )
    end

    if status == "Confirmed"
      OrderMailer.confirm_order(customer, self).deliver
      return true
    else
      return false
    end
  end

  def process
    return false unless self.status == "Confirmed"
    if self.update_column(:status, "Processed")
      self.order_items.each do |item|
        unless item.product.digital
          item.product.update_column(:quantity, item.product.quantity - item.quantity)
        end
        # backorder = 0 - product.quantity if product.quantity < 0
      end
      OrderMailer.process_order(user, self).deliver
      return true
    else
      return false
    end
  end


  def ship
    return false unless status == "Processed"
    if self.update_column(:status, "Shipped")
      OrderMailer.ship_order(user, self).deliver
      return true
    else
      return false
    end
  end
end
