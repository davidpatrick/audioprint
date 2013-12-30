module ProductsHelper
  def print_stock(item, requested = nil)
    if item.digital
      'Digital'
    elsif requested
      if requested < item.quantity
        'In Stock'
      else
        'Insufficient Stock'
      end
    elsif item.quantity > 0
      "In Stock: #{item.quantity}"
    else
      "Out of Stock"
    end
  end
end
