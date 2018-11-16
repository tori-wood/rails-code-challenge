class OrdersController < ApplicationController
  def index
    @orders = Order.all

    @shipped_orders = Order.shipped.latest
    @unshipped_orders = Order.unshipped
  end

  def show
    @order = Order.find(params[:id])
  end
end
