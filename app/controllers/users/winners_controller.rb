class Users::WinnersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_winner
  before_action :set_address, only: :update

  def show; end

  def update
    if @winner.claim! && @winner.update(address: @address)
      flash[:notice] = "Claimed Successfully !"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ') || 'Failed'
    end
    redirect_to users_profile_path
  end

  private

  def set_winner
    @winner = Winner.where(user: current_user).find(params[:id])
  end

  def set_address
    @address = Address.where(user: current_user).find(params[:winner][:address])
  end
end