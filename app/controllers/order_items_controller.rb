class OrderItemsController < ApplicationController
  before_filter :load_order, only: [:create]

  def create
    product = params[:type].classify.constantize.without_deleted.find_by_id(params[:id])
    render :file => 'public/404.html', :layout => false and return unless product

    @order_item =  @order.order_items.find_or_initialize_by(product_id: product.id, product_type: product.class.to_s)
    @order_item.quantity += 1

    respond_to do |format|
      if @order_item.save
        format.html { redirect_to @order, notice: "The #{params[:type]} has been added to your cart." }
        format.json { render json: @order_item, status: :created, location: @order }
      else
        format.html { redirect_to @order, flash: {alert: @order_item.errors.full_messages.join("\n")} }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @order_item = OrderItem.find(params[:id])

    if params[:add_quantity]
      @order_item.quantity += 1
    elsif params[:subtract_quantity]
      @order_item.quantity -= 1
      if @order_item.quantity <= 0
        @order_item.destroy
        render json: {deleted: true, id: @order_item.id}, status: 200
        return
      end
    end

    respond_to do |format|
      if params[:add_quantity] && !stock_check(@order_item.product, @order_item.quantity)
        format.json { render json: 'There is not enough in stock.', status: :unprocessable_entity}
      elsif @order_item.save
        format.html { redirect_to @order_item, notice: 'Order item was successfully updated.' }
        format.json { render json: {
          id: @order_item.id,
          quantity: @order_item.quantity,
          stock: @order_item.product_type == 'Album' ? print_stock(@order_item.product, @order_item.quantity) : nil,
          subtotal: ActionController::Base.helpers.number_to_currency(@order_item.subtotal),
          total: ActionController::Base.helpers.number_to_currency(@order_item.order.total)},
          status: 200
        }
      else
        format.html { render action: "edit" }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_items/1
  # DELETE /order_items/1.json
  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy

    respond_to do |format|
      if @order_item.destroyed?
        format.html { redirect_to @order_item.order }
        format.json { render json: { id: @order_item.id }, status: 200 }
      else
        format.html { redirect_to @order_item.order }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end
end