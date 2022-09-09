class Admin::BonusesController < AdminController
  before_action :set_user

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.genre = :bonus
    @order.user = @user
    if @order.save
      if @order.may_pay? && @order.pay!
        flash[:notice] = "Add Bonus Successfully"
      else
        flash[:alert] = "Transaction failed"
        @order.cancel!
      end
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to new_admin_user_increase_path
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def order_params
    params.require(:order).permit(:coin, :remarks)
  end
end