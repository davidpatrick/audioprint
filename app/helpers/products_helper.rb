module ProductsHelper
  def print_stock(stock)
    if stock > 0
      "In Stock: #{stock}"
    else
      "Out of Stock"
    end
  end
end
