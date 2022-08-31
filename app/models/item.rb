class Item < ApplicationRecord
  validates :image, :name, :online_at, :offline_at, :start_at, :status, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :minimum_bets, numericality: { greater_than: 0 }
  belongs_to :category
  has_many :bets

  mount_uploader :image, ImageUploader

  enum status: [:active, :inactive]

  default_scope { where(deleted_at: nil) }

  def destroy
    if self.bets.blank?
      update(deleted_at: Time.current)
    else
      errors.add(:base, "Can't delete this item")
      return false
    end
  end

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting, after: :set_count, guards: [:greater_than_zero?, :offline_future?, :active?]
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: [:starting, :paused], to: :ended, after: :select_winner, guards: [:count_minimum_bets?]
    end

    event :cancel, after: [:increment_quantity, :cancel_bet] do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  def return_item
    update(quantity: quantity + 1)
  end

  def cancel_bet
    bets.where(batch_count: batch_count).where.not(state: :cancelled).each { |bet| bet.cancel! }
  end

  def set_count
    update(quantity: quantity - 1, batch_count: batch_count + 1)
  end

  def greater_than_zero?
    quantity >= 0
  end

  def offline_future?
    Time.now < offline_at
  end

  def increment_quantity
    update(quantity: quantity + 1)
  end

  def count_minimum_bets?
    bets.where(batch_count: batch_count).count >= minimum_bets
  end

  def select_winner
    item_bets = bets.where(batch_count: batch_count).where.not(state: :cancelled)
    bet_winner = item_bets.sample
    bet_winner.win!
    item_bets.where.not(state: :won).update(state: :lost)
    winner = Winner.new(item_batch_count: bet_winner.batch_count, user: bet_winner.user, item: bet_winner.item, bet: bet_winner, address: bet_winner.user.addresses.find_by(is_default: true))
    winner.save!
  end
end


