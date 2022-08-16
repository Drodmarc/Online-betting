class Item < ApplicationRecord
  validates_presence_of  :image
  validates_presence_of :name
  validates_presence_of  :quantity
  validates_presence_of  :minimum_bets
  validates_presence_of  :online_at
  validates_presence_of :offline_at
  validates_presence_of  :start_at
  validates_presence_of  :status
  belongs_to :category

  mount_uploader :image, ImageUploader

  enum status: [:Active, :Inactive]

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting, after: :start, guards: [:start, :greaterthan_zero?, :future?, :active?]
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

  def start
    self.update(quantity: self.quantity - 1, batch_count: self.batch_count + 1)
  end

  def greaterthan_zero?
    self.quantity > 0
  end

  def future?
    Time.now < offline_at
  end

  def active?
    status == 'Active'
  end
end
