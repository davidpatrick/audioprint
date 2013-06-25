module ProductsHelper
  def print_stock(stock, requested = nil)
    if requested && requested > stock
      'Insufficient Stock'
    elsif stock > 0
      "In Stock: #{stock}"
    else
      "Out of Stock"
    end
  end
end
