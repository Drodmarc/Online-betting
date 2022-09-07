class Users::FeedbacksController < ApplicationController
  before_action :set_winner, only: :show

  def index
    @winners = Winner.includes(:user).published.order(id: :desc)
  end

  def show; end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end
end