class OrdersController < ApplicationController
  def index
    @orders = Order.all

    @shipped_orders = Order.shipped.latest
    @unshipped_orders = Order.unshipped
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
    @order.line_items.build
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      flash[:success] = "Your order has been submitted. We'll let you know when we send it your way!"
      redirect_to @order
    else
      flash[:error] = "There seems to be an issue with your order."
      render action: "new"
    end
  end

  private

  def order_params
    params.fetch(:order, {}).permit(:expedite, line_items_attributes: [:id, :widget_id, :quantity, :unit_price, :_destroy])
  end
end
