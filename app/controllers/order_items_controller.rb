class OrderItemsController < ApplicationController
  before_filter :load_order, only: [:create]

  def create
    @order_item =  @order.order_items.find_or_initialize_by_product_id_and_product_type(params[:id], params[:type].classify)
    @order_item.quantity += 1

    respond_to do |format|
      if @order_item.save
        format.html { redirect_to @order, notice: "The #{params[:type]} has been added to your cart." }
        format.json { render json: @order_item, status: :created, location: @order }
      else
        format.html { render action: "new" }
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
      if @order_item.save
        format.html { redirect_to @order_item, notice: 'Order item was successfully updated.' }
        format.json { render json: {id: @order_item.id, quantity: @order_item.quantity, stock: print_stock(@order_item.product.quantity, @order_item.quantity), subtotal: ActionController::Base.helpers.number_to_currency(@order_item.subtotal), total: ActionController::Base.helpers.number_to_currency(@order_item.order.total)}, status: 200 }
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