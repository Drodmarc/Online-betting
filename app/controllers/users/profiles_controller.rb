class Users::ProfilesController < ApplicationController
  def show
    @orders = Order.where(user: current_user).order(id: :desc) if params[:records] == 'order' || params[:records].blank?
    @bets = Bet.includes(:item).where(user: current_user).order(id: :desc) if params[:records] == 'bet'
    @winners = Winner.includes(:item, :bet).where(user: current_user).order(id: :desc) if params[:records] == 'winner'
    @invites = User.where(parent: current_user).order(id: :desc) if params[:records] == 'invite'
  end
end