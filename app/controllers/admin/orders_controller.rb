class Admin::OrdersController < ApplicationController
  before_action :set_order, except: :index

  def index
    @orders = Order.includes(:user, :offer)
    @total_amount= @orders.map(&:amount).sum
    @total_coin= @orders.map(&:coin).sum
    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.where(user: { email: params[:email] }) if params[:email].present?
    @orders = @orders.where(state: params[:state]) if params[:state].present?
    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?
    @orders = @orders.where(offer: { name: params[:name] }) if params[:name].present?
    @orders = @orders.where(created_at: params[:start].to_datetime..params[:end].to_datetime) if params[:start].present? && params[:end].present?
    @subtotal_amount = @orders.map(&:amount).sum
    @subtotal_coin= @orders.map(&:coin).sum
  end

  def pay
    if @order.pay!
      flash[:notice] = "Paid Successfully"
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to admin_orders_path
  end

  def cancel
    if @order.cancel!
      flash[:notice] = "Canceled Successfully"
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to admin_orders_path
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end
end