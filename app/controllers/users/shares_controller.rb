class Users::SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_winner

  def show; end

  def update
    if @winner.update(winner_params) && @winner.share!
      flash[:notice] = "Shared Feedback Successfully !"
      redirect_to users_profile_path(records: :winner)
    else
      flash[:alert] = @winner.errors.full_messages.join(', ') || 'Failed'
      render :show
    end
  end

  private

  def set_winner
    @winner = Winner.where(user: current_user).delivered.find(params[:id])
  end

  def winner_params
    params.require(:winner).permit(:comment, :picture)
  end
end