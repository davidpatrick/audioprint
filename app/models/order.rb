class Order < ActiveRecord::Base
  attr_accessible :status, :user, :address_id
  belongs_to :user, foreign_key: :user_id
  belongs_to :address
  has_many :order_items, dependent: :destroy
  validates_presence_of :address_id

  def self.status_types
    ["Unsubmitted", "Confirmed", "Processed", "Shipped"]
  end

  def total
    self.order_items.collect(&:subtotal).sum
  end
end
