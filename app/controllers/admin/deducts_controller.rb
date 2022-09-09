class Admin::DeductsController < AdminController
  before_action :set_user

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.genre = :deduct
    @order.user = @user
    if @order.save
      if @order.may_pay? && @order.pay!
        flash[:notice] = "Successfully Deducted"
      else
        flash[:alert] = @order.errors.full_messages.join(', ') || 'Transaction failed'
        @order.cancel!
      end
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to new_admin_user_deduct_path
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def order_params
    params.require(:order).permit(:coin, :remarks)
  end
end