class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/', :alert => exception.message
  end

  def authorize_admin
    authenticate_user!
    raise CanCan::AccessDenied unless current_user.has_role? :admin
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
      raise ActiveRecord::RecordNotFound unless @order && @order.status == "Unsubmitted"

      if current_user && !@order.user
        @order.user = current_user
        @order.save
      elsif current_user && @order.user != current_user
        raise ActiveRecord::RecordNotFound
      end

    rescue ActiveRecord::RecordNotFound
      if current_user
        @order = current_user.orders.find_or_create_by(status: "Unsubmitted")
      else
        @order = Order.create(status: "Unsubmitted")
      end
      session[:order_id] = @order.id
    end
  end

  def is_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end
end
