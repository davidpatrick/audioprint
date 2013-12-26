class Address < ActiveRecord::Base
  attr_accessible :city, :line1, :line2, :state, :user_id, :zip
  validates_presence_of :city, :line1, :state, :zip
  # validates_format_of :zip, :with => /^\d{5}(-\d{4})?$/, :message => "should be in the form 12345 or 12345-1234"
  belongs_to :user
  has_many :orders

  def to_s
    [self.line1, self.line2, self.city, self.state, self.zip].reject{|x| x.blank?}.join(" ")
  end
end
