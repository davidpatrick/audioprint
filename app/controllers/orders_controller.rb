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

    @order = Order.find(params[:id])

    if @order.process(current_user)
      redirect_to orders_path, notice: 'This order has been processed.'
    else
      redirect_to orders_path, alert: 'There was an error processing this order.'
    end
  end

  def tracking_confirmation

  end

  def ship_order
    authorize_admin

    @order = Order.find(params[:id])
    redirect_to @order, alert: "This order cannot be processed" unless @order.status == "Processed"

    if @order.ship(current_user)
      redirect_to orders_path, notice: 'This order has now been shipped!'
    else
      redirect_to orders_path, alert: 'There was an error with this order.'
    end
  end


  def checkout_address
    authenticate_user!
    @order = Order.find(params[:id])
    sign_out current_user unless can? :manage, @order

    @addresses = Address.where(user_id: current_user.id).order(updated_at: :desc)
    @address =  @addresses.last
    @address ||= Address.new()
  end

  def save_address
    authenticate_user!

    @order = Order.find(params[:id])
    sign_out current_user unless can? :manage, @order

    @address = Address.find_by_id(params[:preloaded_address]) if params[:preloaded_address].present?
    @address ||= Address.new(params[:address])
    @address.user_id = current_user.id if params[:save_it]

    @order.address = @address

    binding.pry
    if @order.save
      render json: {order: @order, address: @address}, status: :created
    else
      render json: {order: @order.errors, address: @address.errors}, status: :unprocessable_entity
    end
  end

  def checkout
    authenticate_user!
    @order = Order.find(params[:id])
    sign_out current_user unless can? :manage, @order

    if !params[:type] || params[:type] == '' #address
      @address = Address.where(user_id: current_user.id).order(updated_at: :desc).last
      @address ||= Address.new()
    elsif params[:type] == 'payment'
      @checkout_url = checkout_payment_order_path(@order)
      binding.pry
    elsif params[:type] == 'payment'
      @checkout_url = checkout_purchase_order_path(@order)
    end

    @order.errors.add(:error, ": You don't have any items in your cart") unless @order.order_items.any?
    render action: "show" and return if @order.errors.any?
  end

  def purchase
    authenticate_user!
    @order = Order.find(params[:id])
    sign_out current_user unless can? :manage, @order

    @order.errors.add(:error, ": You forgot to set an address!") unless params[:order][:address_id].present?
    render action: "show" and return if @order.errors.any?

    params[:order][:status] = Order.status_types.second

    respond_to do |format|
      if @order.update_attributes(params[:order])
        session[:order_id] = nil #reset session order
        # OrderMailer.confirm_order(current_user, @order).deliver

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
    unless current_user
      load_order
    else
      @order = Order.find(params[:id])
    end

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
