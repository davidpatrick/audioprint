class Order < ActiveRecord::Base
  attr_accessible :status, :user_id
  belongs_to :user
  has_many :order_items, dependent: :destroy

  def self.status_types
    ["Unsubmitted", "Confirmed", "Processed", "Shipped"]
  end

  def total
    self.order_items.collect(&:subtotal).sum
  end
end
