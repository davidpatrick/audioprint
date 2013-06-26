class OrdersController < ApplicationController
  load_and_authorize_resource

  def view_cart
    load_order

    respond_to do |format|
      format.html { redirect_to @order }
      format.json { render json: @order }
    end
  end

  def process_order
    authorize_admin
    redirect_to root_path unless current_user.has_role? :admin

    @order = Order.find(params[:id])
    @order.status = Order.status_types.third

    if @order.save
      redirect_to orders_path, notice: 'This order has been processed.'
    else
      redirect_to orders_path, alert: 'There was an error processing this order.'
    end
  end

  def purchase
    authenticate_user!
    @order = Order.find(params[:id])
    sign_out current_user unless can? :manage, @order

    @order.errors.add(:address, "Whoops! You forgot to set an address!") unless params[:order][:address_id].present?
    @order.errors.add(:items, "You don't have any items in your cart") unless @order.order_items.any?

    if @order.errors.any?
      render action: "show"
      return
    end

    params[:order][:status] = Order.status_types.second

    respond_to do |format|
      if @order.update_attributes(params[:order])
        session[:order_id] = nil #reset session order

        format.html { redirect_to @order, notice: 'Your order was successfully placed.' }
        format.json { head :no_content }
      else
        format.html { render action: "show" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    authenticate_user!

    if current_user.has_role? :admin
      @orders = Order.all
    else
      @orders = Order.where(user_id: current_user.id)
    end

    respond_to do |format|
      if current_user.has_role? :admin
        format.html { render :template => "orders/manage" }
      else
        format.html
      end
      format.json { render json: @orders }
    end
  end


  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new(params[:order])

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
end
