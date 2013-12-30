class OrdersController < ApplicationController
  load_and_authorize_resource

  def view_cart
    load_order

    respond_to do |format|
      format.html { redirect_to @order }
      format.json { render json: @order }
    end
  end

  def checkout
    authenticate_user!
    @order = Order.find(params[:id])
    sign_out current_user unless can? :manage, @order

    @address = Address.where(user_id: current_user.id).order(updated_at: :desc).last
    @address ||= Address.new()

    if @order.order_items.empty?
      @order.errors.add(:error, ": You don't have any items in your cart")
    end

    if @order.status != 'Unsubmitted'
      @order.errors.add(:error, ": This order can not be processed")
    end

    if @order.errors.any?
      render action: "show"
    end
  end


  def save_address
    authenticate_user!

    @order = Order.find(params[:id])
    sign_out current_user unless can? :manage, @order

    @address = Address.find_by_id(params[:preloaded_address]) if params[:preloaded_address].present?
    @address ||= Address.new(params[:address])
    @address.user_id = current_user.id if params[:save_it]

    @order.address = @address

    if @order.save && @address.save
      render json: {order: @order, address: @address}, status: :created
    else
      render json: {order: @order.errors, address: @address.errors}, status: :unprocessable_entity
    end
  end

  def review_and_submit
    authenticate_user!

    @order = Order.find(params[:id])
    sign_out current_user unless can? :manage, @order

    if @order.is_valid? && @order.confirm(current_user, { stripe_card_token: params[:stripe_card_token] })
      redirect_to @order
    else
      render action: "checkout"
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
