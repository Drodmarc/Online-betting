class Order < ApplicationRecord
  belongs_to :user
  belongs_to :offer, optional: true

  enum genre: [:deposit, :increase, :deduct, :bonus, :share]
  after_create :generate_serial_number

  validates :amount, numericality: { greater_than: 0 }, if: :deposit?
  validates :amount, numericality: { greater_than_or_equal: 0 }, unless: :deposit?



  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:pending, :submitted], to: :cancelled
      transitions from: :paid, to: :cancelled, after: [:after_cancel_update_coins, :deduct_total_deposit], guard: [:check_user_coins?]
    end

    event :pay do
      transitions from: :submitted, to: :paid, after: [:after_pay_update_coins, :increase_total_deposit]
    end
  end

  def after_pay_update_coins
    if deduct?
      user.update(coins: user.coins - coin)
    else
      user.update(coins: user.coins + coin)
    end
  end

  def increase_total_deposit
    user.update(total_deposit: user.total_deposit + amount) if deposit?
  end

  def after_cancel_update_coins
    if deduct?
      user.update(coins: user.coins + coin)
    else
      user.update(coins: user.coins - coin)
    end
  end

  def deduct_total_deposit
    user.update(total_deposit: user.total_deposit - amount) if deposit?
  end

  def check_user_coins?
    return true if (user.coins > coin) && !deduct?
    errors.add(:base, "You deducted too much coins")
    false
  end

  def generate_serial_number
    ActiveRecord::Base.connection.execute("UPDATE `bets` SET `bets`.`serial_number` = CONCAT(DATE_FORMAT(CONVERT_TZ(bets.created_at, '+00:00', '+8:00'), '%y%m%d'),'-',#{id},'-',#{user.id},'-',
                                                      (SELECT LPAD(count(*), 4, 0)
                                                       FROM `bets` where `bets`.`user_id` = #{user.id}
                                                       WHERE bets.id = #{id}")
  end
end



