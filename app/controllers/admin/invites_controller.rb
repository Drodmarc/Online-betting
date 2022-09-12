class Admin::InvitesController < AdminController
  def index
    @users = User.includes(:parent, :children, :bets).where(role: :client).where.not(parent: nil)
    @users = @users.where(parent: { email: params[:parent_email] }) if params[:parent_email].present?
  end
end