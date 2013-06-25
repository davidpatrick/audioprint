class ApplicationController < ActionController::Base
  protect_from_forgery
  before_logout :destroy_order

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/', :alert => exception.message
  end

  def print_stock(stock, requested = nil)
    if requested && requested > stock
      'Insufficient Stock'
    elsif stock > 0
      "In Stock: #{stock}"
    else
      "Out of Stock"
    end
  end

  def load_order
    begin
      @order = Order.find(session[:order_id])
    rescue ActiveRecord::RecordNotFound
      if current_user
        @order = current_user.orders.find_or_create_by_status("unsubmitted")
      else
        @order = Order.create(status: "unsubmitted")
      end
      session[:order_id] = @order.id
    end
  end

end
