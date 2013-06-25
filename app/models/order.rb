class Order < ActiveRecord::Base
  attr_accessible :status, :user
  belongs_to :user, foreign_key: :user_id
  has_many :order_items, dependent: :destroy

  def self.status_types
    ["Unsubmitted", "Confirmed", "Processed", "Shipped"]
  end

  def total
    self.order_items.collect(&:subtotal).sum
  end
end
