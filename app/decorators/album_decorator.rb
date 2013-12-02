class AlbumDecorator
  include ApplicationHelper
  include Rails.application.routes.url_helpers

  attr_reader :album

  def initialize(album)
    @album = album
  end

  # def method_missing(method_name, *args, &block)
  #   post.send(method_name, *args, &block)
  # end

  # def respond_to_missing?(method_name, include_private = false)
  #   post.respond_to?(method_name, include_private) || super
  # end

  def add_to_cart
    html = if @album.quantity > 0
      " <a href='#{add_album_to_cart_path(@album)}' class='button'>
          Add to Cart
          <i class='fa fa-shopping-cart'></i>
        </a>
      "
    else
      " <div class='button disabled'>
          Out of Stock
          <i class='fa fa-shopping-cart'></i>
        </div>
      "
    end
    html.html_safe
  end

  def display
    "#{@album.title} - #{@album.artist}".html_safe
  end
end