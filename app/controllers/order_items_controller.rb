class OrderItemsController < ApplicationController
  before_filter :load_order, only: [:create]

  def load_order
    @order = Order.find_or_initialize_by_id(session[:order_id], status: "unsubmitted")
    if @order.new_record?
      @order.save!
      session[:order_id] = @order.id
    end

    # begin
    #   @order = Order.find(session[:order_id])
    # rescue ActiveRecord::RecordNotFound
    #   @order = Order.create(status: Order.status_types.first)
    #   session[:order_id] = @order.id
    # end
  end

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

  # PUT /order_items/1
  # PUT /order_items/1.json
  def update
    @order_item = OrderItem.find(params[:id])

    respond_to do |format|
      if @order_item.update_attributes(params[:order_item])
        format.html { redirect_to @order_item, notice: 'Order item was successfully updated.' }
        format.json { head :no_content }
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
      format.html { redirect_to @order_item.order }
      format.json { head :no_content }
    end
  end
end