class Item < ApplicationRecord
  validates :image, :name, :online_at, :offline_at, :start_at, :status, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :minimum_bets, numericality: { greater_than: 0 }
  belongs_to :category

  mount_uploader :image, ImageUploader

  enum status: [:active, :inactive]

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
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
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  def set_count
    update_columns(quantity: quantity - 1, batch_count: batch_count + 1)
  end

  def greater_than_zero?
    quantity > 0
  end

  def offline_future?
    Time.now < offline_at
  end
end
